// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/time;
import ballerina/lang.'string as stringLib;
import ballerina/lang.'xml as xmlLib;
import ballerina/lang.map as mapLib;

isolated function buildHeader(NetsuiteConfiguration config) returns string|error {
    time:Time timeNow = time:currentTime();
    string timeToSend = stringLib:substring(timeNow.time.toString(), 0, 10);
    string uuid = getRandomString();
    string signature = check getNetsuiteSignature(timeToSend, uuid, config);
    string header = string `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:urn="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:urn1="urn:core_2020_2.platform.webservices.netsuite.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
    <urn:tokenPassport><urn1:account>${
    config.accountId}</urn1:account>
    <urn1:consumerKey>${config.consumerId}</urn1:consumerKey>
    <urn1:token>${
    config.token}</urn1:token>
    <urn1:nonce>${uuid}</urn1:nonce>
    <urn1:timestamp>${timeToSend}</urn1:timestamp>
    <urn1:signature algorithm="HMAC-SHA256">${
    signature}</urn1:signature>
    </urn:tokenPassport>
    </soapenv:Header>`;
    return header;
}

function setRecordRef(RecordRef recordRef, string? XSDName = ()) returns string {
    string? externalId = recordRef?.externalId;
    string recordType = recordRef.'type;
    string xmlRecord = string `<${recordType} xsi:type="urn1:RecordRef" internalId="${recordRef.internalId}"/>`;
    if (externalId is string) {
        xmlRecord = string `<${recordType} xsi:type="urn1:RecordRef" internalId="${recordRef.internalId}" 
        externalId="${externalId}"/>`;
    } 
    return xmlRecord;
}

function setSimpleType(string elementName, string|boolean|decimal|int value, string XSDName) returns string {
    if (value is string) {
        return string `<${XSDName}:${elementName}>${value}</${XSDName}:${elementName}>`;
    } else {
        return string `<${XSDName}:${elementName}>${value.toString()}</${XSDName}:${elementName}>`;
    }
}

function buildAddRecordPayload(RecordCreationInfo info, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string elements = setRecordAddingOperationFields(info);
    string body = string `<soapenv:Body>
    <urn:add>
            ${elements.toString()}
    </urn:add>
    </soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    //log:print(xmlPayload.toString());
    return xmlPayload;
}

function buildDeleteRecordPayload(RecordDeletionInfo info, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string elements = setDeletePayload(info);
    string body = string `<soapenv:Body>
    <urn:delete>
            ${elements.toString()}
    </urn:delete>
    </soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

function buildUpdateRecordPayload(RecordUpdateInfo request, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string elements = setRecordUpdatingOperationFields(request);
    string body = string `<soapenv:Body>
    <urn:update>
            ${elements.toString()}
    </urn:update>
    </soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

function setRecordUpdatingOperationFields(RecordUpdateInfo info) returns string {
    if (info.recordType == CUSTOMER) {
        string requestXml = MapCustomerRequestValue(<Customer>info.instance);
        return string `<urn:record xsi:type="listRel:Customer" internalId="${info.internalId}" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${requestXml.toString()}
         </urn:record>`; 
    }else if (info.recordType == CONTACT) {
        string requestXml = MapContactRequestValue(<Contact>info.instance);
        return string `<urn:record xsi:type="listRel:Contact" internalId="${info.internalId}"
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${info.toString()}
         </urn:record>`;
    } else if (info.recordType == CURRENCY) {
        string requestXml = MapCurrencyRequestValue(<Currency>info.instance);
        return string `<urn:record xsi:type="listAcct:Currency" internalId="${info.internalId}"
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${requestXml.toString()}
         </urn:record>`;
    } else if (info.recordType == SALES_ORDER) {
        string requestXml = mapSalesOrderRequestValue(<SalesOrder>info.instance);
        return string `<urn:record xsi:type="tranSales:SalesOrder" internalId="${info.internalId}"
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${requestXml.toString()}
         </urn:record>`;
    }
    return "";
}


function setRecordAddingOperationFields(RecordCreationInfo info) returns string {
    if (info.recordType == CUSTOMER) {
        string rquestXml = MapCustomerRequestValue(<Customer>info.instance);
        return string `<urn:record xsi:type="listRel:Customer" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`; 
    }else if (info.recordType == CONTACT) {
        string rquestXml = MapContactRequestValue(<Contact>info.instance);
        return string `<urn:record xsi:type="listRel:Contact" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    } else if (info.recordType == CURRENCY) {
        string rquestXml = MapCurrencyRequestValue(<Currency>info.instance);
        return string `<urn:record xsi:type="listAcct:Currency" 
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    } else if (info.recordType == SALES_ORDER) {
        string rquestXml = mapSalesOrderRequestValue(<SalesOrder>info.instance);
        return string `<urn:record xsi:type="tranSales:SalesOrder" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    } else if (info.recordType == INVOICE) {
        string rquestXml = mapInvoiceRequestValue(<Invoice>info.instance);
        return string `<urn:record xsi:type="tranSales:Invoice" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    }
    return "";
}

function setDeletePayload(RecordDeletionInfo info) returns string{
    if(info?.deletionReasonId is () || info?.deletionReasonMemo is ()) {
        return string `<urn:baseRef type="${info.recordType}" internalId="${info.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>`;
    } else {
        return string `<urn:baseRef type="${info.recordType}" internalId="${info.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>
        <urn1:deletionReason>
        <deletionReasonCode internalId="${info?.deletionReasonId.toString()}"/>
        <deletionReasonMemo>${info?.deletionReasonMemo.toString()}</deletionReasonMemo>
        </urn1:deletionReason>`;   
    }  
}
//-------------------------get functions
isolated function buildGetAllPayload(string recordType, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string body = string `<soapenv:Body><urn:getAll><record recordType="${recordType}"/></urn:getAll></soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function buildGetSavedSearchPayload(string recordType, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string body = string`<soapenv:Body><urn:getSavedSearch><urn:record searchType="${recordType}"/></urn:getSavedSearch>
    </soapenv:Body></soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

//-------------------------search functions-----------------------------------------------------------------------------
function buildSearchPayload(NetsuiteConfiguration config, RecordSearchInfo searchInfo) returns xml|error {
    string header  =check buildHeader(config);
    string searchElements = "";
    string completeBody = "";
    string recordType = searchInfo.recordType;
    match recordType {
        CUSTOMER_TYPE => {
            searchElements = check setInternalXmlSearchElement(searchInfo.searchDetail, customerSearchParts);
            completeBody = setCustomerSearchRequestBody(searchElements);
        }
    }
    string payload = header + completeBody;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function setCustomerSearchRequestBody(string SearchElements) returns string {
    string body =  string `<soapenv:Body> <urn:search xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
    <urn:searchRecord xsi:type="listRel:CustomerSearch" 
    xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
    <basic xsi:type="ns1:CustomerSearchBasic" 
    xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">${SearchElements}</basic>
    </urn:searchRecord></urn:search></soapenv:Body></soapenv:Envelope>`;
    return body;
}

isolated function setInternalXmlSearchElement(SearchField[] searchfields, map<string> searchPart) returns string|error {
    string basicSearchElement = "";
    if(searchfields.length() != 0) {
        foreach SearchField item in searchfields {
            string elementName = item?.elementName.toString();
            if(elementName != "" && mapLib:hasKey(searchPart, elementName)) {
                string fieldType = searchPart.get(elementName);
                if(fieldType == "SearchStringField") {
                    basicSearchElement =  basicSearchElement + getSearchStringFieldElement(item);
                } else if (fieldType == "SearchMultiSelectField") {
                    basicSearchElement =  basicSearchElement + getSearchMultiSelectFieldElement(item);
                } else if (fieldType == "SearchDateField") {
                    basicSearchElement =  basicSearchElement + check getDateFieldElement(item);
                } else if (fieldType == "SearchDoubleField") {
                    basicSearchElement =  basicSearchElement + check getSearchDoubleFieldElemet(item);
                } else if (fieldType == "SearchEnumMultiSelectField") {
                    basicSearchElement =  basicSearchElement + getSearchEnumMultiSelectField(item);
                }
            } else if(elementName == "" && (item.operator.toString() == ANYOF || item.operator.toString() == NONEOF)) {
                basicSearchElement =  basicSearchElement  + getNonOperatorElement(item);
            } else {
                fail error
                ("Element is not vaild, Please check the element type support for BasicSearches in Netsuite SOAP service");
            }
        }
        return basicSearchElement;
    } else {
        fail error("No any search fields have been set before using this remote function.");
    }
}

isolated function getNonOperatorElement(SearchField item) returns string {
    return string `<ns1:type operator="${item.operator.toString()}" xsi:type="urn1:SearchEnumMultiSelectField">
    <urn1:searchValue xsi:type="xsd:string">${item?.value.toString()}</urn1:searchValue></ns1:type>`;
}

isolated function getSearchStringFieldElement(SearchField item) returns string { 
    string searchStringFieldTemplate =  string `<ns1:${item?.elementName.toString()} 
    operator="${item.operator.toString()}" 
    xsi:type="urn1:SearchStringField"><urn1:searchValue>${item?.value.toString()}</urn1:searchValue>
    </ns1:${item?.elementName.toString()}>`;
    return searchStringFieldTemplate;
}

isolated function getSearchMultiSelectFieldElement(SearchField item) returns string {
    //string searchMultiSelectFieldTemplate = string `<${item?.elementName.toString()}  operator="${item.operator.toString()}" xsi:type="urn1:SearchMultiSelectField">    <urn1:searchValue xsi:type="urn1:RecordRef">      <name internalId="${item?.internalId.toString()}" externalId="${item?.externalId.toString()}" type = "platformCoreTyp:RecordType" xmlns:platformCoreTyp = "urn:types.core_2020_2.platform.webservices.netsuite.com">${item?.value.toString()}</name></urn1:searchValue></${item?.elementName.toString()}>`;
    //return searchMultiSelectFieldTemplate;
    string value = "";
    if(item?.internalId != "") {
        value = string `<${item?.elementName.toString()}  operator="${item.operator.toString()}" 
        xsi:type="urn1:SearchMultiSelectField">
        <urn1:searchValue internalId="${item?.internalId.toString()}"  xsi:type="urn1:RecordRef"/>
        </${item?.elementName.toString()}>`;
    } else if( item?.externalId != "") {
        value = string `<${item?.elementName.toString()}  operator="${item.operator.toString()}" 
        xsi:type="urn1:SearchMultiSelectField">
        <urn1:searchValue externalId="${item?.externalId.toString()}"  xsi:type="urn1:RecordRef"/>
        </${item?.elementName.toString()}>`;
    }
    return value;
}

isolated function getDateFieldElement(SearchField item) returns string|error {    
    DateField? dates = item?.dateField;
    if(!(dates is ())) {
        if(!(dates?.preDefinedDate is ())) {
            return string `<ns1:${item?.elementName.toString()} operator="${dates.operator.toString()}" 
            xsi:type="urn1:SearchDateField">
            <urn1:predefinedSearchValue xsi:type="ns11:SearchDate" 
            xmlns:ns11="urn:types.core_2017_1.platform.webservices.netsuite.com">
            ${dates?.preDefinedDate.toString()}
            </urn1:predefinedSearchValue>
            </ns1:${item?.elementName.toString()}>`;
        } else if(!(dates?.date is ()) && dates?.date is () ) { //ToDo: add more validation
            return string `<ns1:${item?.elementName.toString()} operator="${dates.operator.toString()}" 
            xsi:type="urn1:SearchDateField">
            <urn1:searchValue>${dates?.date.toString()}</urn1:searchValue>
            </ns1:${item?.elementName.toString()}>`;
        } else {
            return string `<ns1:${item?.elementName.toString()} operator="${dates.operator.toString()}" 
            xsi:type="urn1:SearchDateField">
            <urn1:searchValue>${dates?.date.toString()}</urn1:searchValue>
            <urn1:searchValue2>${dates?.date2.toString()}</urn1:searchValue2>
            </ns1:${item?.elementName.toString()}>`;
        }

    } else {
        fail error("No Any Date Record Found");
    }    
}

isolated function getSearchDateFieldElement(SearchField item) returns string { 
    string searchStringFieldTemplate =  string `<${item?.elementName.toString()} operator="${item.operator.toString()}" 
    xsi:type="urn1:SearchStringField"><urn1:searchValue>${item?.value.toString()}</urn1:searchValue>
    </${item?.elementName.toString()}>`;
    return searchStringFieldTemplate;
}

isolated function getSearchEnumMultiSelectField(SearchField item) returns string {
    string searchStringFieldTemplate =  string `<ns1:${item?.elementName.toString()} operator="${item.operator.toString()}" 
    xsi:type="urn1:SearchEnumMultiSelectField"><urn1:searchValue>${item?.value.toString()}</urn1:searchValue>
    </ns1:${item?.elementName.toString()}>`;
    return searchStringFieldTemplate;
}

isolated function getSearchDoubleFieldElemet(SearchField item) returns string|error{
     DoubleField? doubleField = item?.doubleField;
     if(doubleField is DoubleField) {
         if(doubleField.operator == BETWEEN_DFIELD || doubleField.operator == NOTBETWEEN_DFIELD ) {
             return string `<ns1:${item?.elementName.toString()} operator="${doubleField.operator.toString()}" 
             xsi:type="urn1:SearchDoubleField">
            <urn1:searchValue>${doubleField?.searchValue.toString()}</urn1:searchValue>
            <urn1:searchValue2>${doubleField?.searchValue2.toString()}</urn1:searchValue2>
            </ns1:${item?.elementName.toString()}>`;
         } else {
             return string `<ns1:${item?.elementName.toString()} operator="${doubleField.operator.toString()}" 
             xsi:type="urn1:SearchDoubleField">
            <urn1:searchValue>${doubleField?.searchValue.toString()}</urn1:searchValue>
            </ns1:${item?.elementName.toString()}>`;
         }
     } else {
         fail error("No DoubleField is provided");
     }
}
