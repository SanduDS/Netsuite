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

import ballerina/crypto;
import ballerina/lang.'array;
import ballerina/lang.'xml as xmlLib;
import ballerina/lang.'string as stringLib;
import ballerina/time;
import ballerina/uuid;
import ballerina/regex;
import ballerina/lang.value as value;
import ballerina/lang.'map as mapLib;

isolated function getCurrrenttime() returns int {
    time:Time now = time:currentTime();
    int milliSecond = checkpanic time:getMilliSecond(now);
    return milliSecond;

}

isolated function getNetsuiteSignature(string timeNow, string UUID, NetsuiteConfiguration config) returns string|error {
    TokenData tokenData = {
        accountId: config.accountId,
        consumerId: config.consumerId,
        consmerSecret: config.consmerSecret,
        tokenSecret: config.tokenSecret,
        token: config.token,
        nounce: UUID,
        timestamp: timeNow
    };
    string token = check generateSignature(tokenData);
    return token;
}

isolated function getRandomString() returns string {
    string uuid1String = uuid:createType1AsString();
    return regex:replaceAll(uuid1String, "-", "s");
}

isolated function makeBaseString(TokenData values) returns string {
    string token = values.accountId + "&" + values.consumerId + "&" + values.token + "&" + values.nounce + "&" + values.
    timestamp;
    return token;
}

isolated function createKey(TokenData values) returns string {
    string keyValue = values.consmerSecret + "&" + values.tokenSecret;
    return keyValue;
}

isolated function generateSignature(TokenData values) returns string|error {
    string baseString = makeBaseString(values);
    string keyValue = createKey(values);
    byte[] data = baseString.toBytes();
    byte[] key = keyValue.toBytes();
    byte[] hmac = check crypto:hmacSha256(data, key);
    return 'array:toBase64(hmac);
}

isolated function buildGetAllPayload(string recordType, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string body = string `<soapenv:Body><urn:getAll><record recordType="${recordType}"/></urn:getAll></soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function buildGetListPayload(GetListRequestField|GetListRequestField[] records, NetsuiteConfiguration config)        
                                    returns xml|error {
    string header = check buildHeader(config);
    string elements = getListElements(records);
    string body = string `<soapenv:Body><urn:getList xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">${elements}
    </urn:getList></soapenv:Body></soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function buildGetPayload(GetRequestField records, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string elements = getListElements(records);
    string body = string `<soapenv:Body><urn:get xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">${elements}
    </urn:get></soapenv:Body></soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function getListElements(GetRequestField|GetListRequestField|GetListRequestField[] records) returns string {
    string elements = "";
    if(records is GetListRequestField[]) {
        foreach GetListRequestField item in records {
            elements = elements + string `<urn:baseRef internalId="${item.internalId.toString()}" type="${item.recordType.toString()}" xsi:type="urn1:RecordRef"/>`;
        }
    } else {
        elements = string `<urn:baseRef internalId="${records.internalId.toString()}" 
        type="${records.recordType.toString()}" xsi:type="urn1:RecordRef"/>`;
    }
    return elements;
}

isolated function builGetSavedSearchPayload(string recordType, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string body = string`<soapenv:Body><urn:getSavedSearch><urn:record searchType="${recordType}"/></urn:getSavedSearch>
    </soapenv:Body></soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

function buildCustomerSearchPayload(NetsuiteConfiguration config, SearchField[] searchData) returns xml|error {
    string header  =check buildHeader(config);
    string searchElements = check setInternalXmlSearchElement(searchData, customerSearchParts);
    string completeBody = setCustomerSearchRequestBody(searchElements);
    string payload = header + completeBody;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

function buildTransactionSearchPayload(NetsuiteConfiguration config, SearchField[] searchData) returns xml|error {
    string header  =check buildHeader(config);
    string searchElements = check setInternalXmlSearchElement(searchData, TRANSACTION_SEARCH_PARTS);
    string completeBody = setTrasactionRequestBody(searchElements);
    string payload = header + completeBody;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function formatRawJsonResponse(json rawResponse) returns json|error {
    string step = regex:replaceAll(value:toJsonString(rawResponse), "\"@", "\"");
    string steptwo = regex:replaceAll(value:toJsonString(step), "xsi:type", "xsi_type");
    string stepthree = regex:replaceAll(value:toJsonString(steptwo), "\"tranSales:", "\"tranSales_");
    return value:fromJsonString(stepthree);
}

isolated function formatCustomJsons(json value, string valueToRemove, string valueToReplace) returns json|error {
    return value:fromJsonString(regex:replaceAll(value:toJsonString(value), valueToRemove, valueToReplace));
}

isolated function formatRawXMLesponse(xml rawResponse) returns xml|error {
    string stepOne = regex:replaceAll(rawResponse.toString(), "soapenv:", "soapenv_");
    string steptwo = regex:replaceAll(stepOne, "platformCore:", "platformCore_");
    string stepThree = regex:replaceAll(steptwo, "platformMsgs:", "platformMsgs_");
    return xmlLib:fromString(stepThree);

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

isolated function setTrasactionRequestBody(string SearchElements) returns string {
    string body =string `<soapenv:Body><search xmlns="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <searchRecord xsi:type="ns1:TransactionSearchBasic" xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">
    ${SearchElements}
    </searchRecord>
    </search></soapenv:Body>
    </soapenv:Envelope>`;
    return body;
}

isolated function buildHeader(NetsuiteConfiguration config) returns string|error{
    time:Time timeNow = time:currentTime();
    string timeToSend = stringLib:substring(timeNow.time.toString(), 0, 10);
    string uuid = getRandomString();
    string signature = check getNetsuiteSignature(timeToSend, uuid, config);
    string payload = string `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:urn="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:urn1="urn:core_2020_2.platform.webservices.netsuite.com">
    <soapenv:Header>
    <urn:tokenPassport><urn1:account>${config.accountId}</urn1:account>
    <urn1:consumerKey>${config.consumerId}</urn1:consumerKey>
    <urn1:token>${config.token}</urn1:token>
    <urn1:nonce>${uuid}</urn1:nonce>
    <urn1:timestamp>${timeToSend}</urn1:timestamp>
    <urn1:signature algorithm="HMAC-SHA256">${signature}</urn1:signature>
    </urn:tokenPassport>
    </soapenv:Header>`;
    return payload;

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
