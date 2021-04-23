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

import ballerina/http;
import ballerina/time;
import ballerina/lang.'string as stringLib;
import ballerina/lang.'xml as xmlLib;
import ballerina/lang.'boolean as booleanLib;

isolated function doHTTPRequest(http:Client basicClient, string action, xml payload) returns http:Response|error {
    http:Request request = new;
    request.setXmlPayload(payload);
    request.setHeader(SOAP_ACTION_HEADER, action);
    return <http:Response>check basicClient->post(EMPTY_STRING, request);
}

isolated function buildXMLPayloadHeader(NetSuiteConfiguration config) returns string|error {
    time:Utc timeNow = time:utcNow();
    string timeToSend = stringLib:substring(timeNow.toString(), 0, 10);
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

isolated function getXMLRecordRef(RecordRef recordRef) returns string {
    string xmlRecord = string `<${recordRef?.'type.toString()} xsi:type="urn1:RecordRef" 
    internalId="${recordRef.internalId}"/>`;
    string? externalId = recordRef?.externalId;
    if (externalId is string) {
        xmlRecord = string `<${recordRef?.'type.toString()} xsi:type="urn1:RecordRef" 
        internalId="${recordRef.internalId}" 
        externalId="${externalId}"/>`;
    } 
    return xmlRecord;
}

isolated function setSimpleType(string elementName, string|boolean|decimal|int value, string XSDName) returns string {
    if (value is string) {
        return string `<${XSDName}:${elementName}>${value}</${XSDName}:${elementName}>`;
    } else {
        return string `<${XSDName}:${elementName}>${value.toString()}</${XSDName}:${elementName}>`;
    }
}

isolated function getAddXMLBodyWithParentElement(string subElements) returns string {
    return string `<soapenv:Body>
    <urn:add>
            ${subElements}
    </urn:add>
    </soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function getDeleteXMLBodyWithParentElement(string subElements) returns string {
    return string `<soapenv:Body>
    <urn:delete>
            ${subElements}
    </urn:delete>
    </soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function getUpdateXMLBodyWithParentElement(string subElements) returns string {
    return string `<soapenv:Body>
    <urn:update>
            ${subElements}
    </urn:update>
    </soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function buildAddRecordPayload(RecordType info, RecordCoreType recordCoreType, NetSuiteConfiguration config) 
                                returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string subElements = check getRecordElementsForAddOperation(info, recordCoreType);
    string body = getAddXMLBodyWithParentElement(subElements);
    return getSoapPayload(header, body);
}

isolated function buildDeleteRecordPayload(RecordDetail info, NetSuiteConfiguration config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string subElements = getDeletePayload(info);
    string body = getDeleteXMLBodyWithParentElement(subElements);
    return getSoapPayload(header, body);
}

isolated function buildUpdateRecordPayload(RecordType info, RecordCoreType recordCoreType, NetSuiteConfiguration config) 
                                    returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string elements = check getRecordElementsForUpdateOperation(info, recordCoreType);
    string body = getUpdateXMLBodyWithParentElement(elements);
    return getSoapPayload(header, body);    
}

isolated function getRecordElementsForUpdateOperation(RecordType info, RecordCoreType recordCoreType) returns string|error {
    string subElements = EMPTY_STRING;   
    match recordCoreType {
        CUSTOMER => {
             subElements = mapCustomerRecordFields(<Customer>info); 
             return wrapCustomerElementsToBeUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        CONTACT => {
             subElements = mapContactRecordFields(<Contact>info); 
             return wrapContactElementsToBeUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        CURRENCY => {
            subElements = mapCurrencyRecordFields(<Currency>info);
            return wrapCurrencyElementsToBeUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        SALES_ORDER => {
            subElements = mapSalesOrderRecordFields(<SalesOrder>info);
            return wrapSalesOrderElementsToBeUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        CLASSIFICATION => {
            subElements = mapClassificationRecordFields(<Classification>info); 
            return wrapClassificationElementsToBeUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        ACCOUNT => {
            subElements = mapAccountRecordFields(<Account>info); 
            return wrapAccountElementsToUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        INVOICE => {
            subElements = check mapInvoiceRecordFields(<Invoice>info); 
            return wrapInvoiceElementsToBeUpdatedWithParentElement(subElements, info?.internalId.toString());
        }
        _ => {
                fail error(UNKNOWN_TYPE);
        }
    }
}

isolated function getRecordElementsForAddOperation(RecordType info, RecordCoreType recordCoreType) returns string|error{ 
    string subElements = EMPTY_STRING;  
    match recordCoreType {
        CUSTOMER => {
             subElements = mapCustomerRecordFields(<Customer>info); 
             return wrapCustomerElementsToBeCreatedWithParentElement(subElements);
        }
        CONTACT => {
             subElements = mapContactRecordFields(<Contact>info); 
             return wrapContactElementsToBeCreatedWithParentElement(subElements);
        }
        CURRENCY => {
            subElements = mapCurrencyRecordFields(<Currency>info);
            return wrapCurrencyElementsToBeCreatedWithParentElement(subElements);
        }
        SALES_ORDER => {
            subElements = mapSalesOrderRecordFields(<SalesOrder>info);
            return wrapSalesOrderElementsToBeCreatedWithParentElement(subElements);
        }
        INVOICE => {
            subElements = check mapInvoiceRecordFields(<Invoice>info); 
            return wrapInvoiceElementsToBeCreatedWithParentElement(subElements);
        }
        CLASSIFICATION => {
            subElements = mapClassificationRecordFields(<Classification>info); 
            return wrapClassificationElementsToBeCreatedWithParentElement(subElements);
        }
        ACCOUNT => {
            subElements = mapClassificationRecordFields(<Account>info); 
            return wrapAccountElementsToBeCreatedWithParentElement(subElements);
        }
        _ => {
                fail error(UNKNOWN_TYPE);
        }
    }
}

isolated function buildGetOperationPayload(RecordDetail records, NetSuiteConfiguration config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string elements = prepareElementsForGetOperation(records);
    string body = string `<soapenv:Body><urn:get xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">${elements}
    </urn:get></soapenv:Body></soapenv:Envelope>`;
    return getSoapPayload(header, body);
}

isolated function prepareElementsForGetOperation(RecordDetail recordDetail) returns string {
    string elements = string `<urn:baseRef internalId="${recordDetail.recordInternalId}" type="${recordDetail.recordType}"
    xsi:type="urn1:RecordRef"/>`;
    return elements;
}

isolated function getDeletePayload(RecordDetail recordDetail) returns string{
    if(recordDetail?.deletionReasonId is () || recordDetail?.deletionReasonMemo is ()) {
        return getXMLElementForDeletion(recordDetail);
    } else {
        return getXMLElementForDeletionWithDeleteReason(recordDetail);
    }  
}

isolated function getXMLElementForDeletion(RecordDetail recordDetail) returns string {
    return string `<urn:baseRef type="${recordDetail.recordType}" internalId="${recordDetail.recordInternalId}" 
    xsi:type="urn1:RecordRef"/>`;
}

isolated function getXMLElementForDeletionWithDeleteReason(RecordDetail recordDetail) returns string {
    return string `<urn:baseRef type="${recordDetail.recordType}" internalId="${recordDetail.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>
        <urn1:deletionReason>
        <deletionReasonCode internalId="${recordDetail?.deletionReasonId.toString()}"/>
        <deletionReasonMemo>${recordDetail?.deletionReasonMemo.toString()}</deletionReasonMemo>
        </urn1:deletionReason>`;
}

//-------------------------get functions--------------------------------------------------------------------------------
isolated function buildGetAllPayload(string recordType, NetSuiteConfiguration config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string body = getXMLBodyForGetAllOperation(recordType);
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload;
}

isolated function getXMLBodyForGetAllOperation(string recordType) returns string{
    return string `<soapenv:Body><urn:getAll><record recordType="${recordType}"/></urn:getAll></soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function getXMLBodyForSavedSearchOperation(string recordType) returns string{
    return string`<soapenv:Body><urn:getSavedSearch><urn:record searchType="${recordType}"/></urn:getSavedSearch>
    </soapenv:Body></soapenv:Envelope>`;
}

isolated function buildGetSavedSearchPayload(string recordType, NetSuiteConfiguration config) returns xml|error {
    string header = check buildXMLPayloadHeader(config);
    string body = getXMLBodyForSavedSearchOperation(recordType);
    return getSoapPayload(header, body);
}

isolated function getValidJson(json|error element) returns json?{
    if(element is json) {
        return element;
    } 
}

isolated function checkXmlElementValidity(xml|error element) returns xml?{
    if(element is xml) {
        return element;
    } 
}

isolated function checkStringValidity(string|error element) returns string?{
    if(element is string) {
        return element;
    } 
}

isolated function extractBooleanValueFromJson(json|error element) returns boolean|error {
    return booleanLib:fromString(getValidJson(element).toString());
}

isolated function extractBooleanValueFromXMLOrText(xml|string|error element) returns boolean|error {
   if(element is xml|string) {
       return booleanLib:fromString(element.toString()); 
   } else {
       return element;
   }
   
}

isolated function getRecordRef(json element, json elementInfo) returns RecordRef {
    RecordRef recordRef = {
        name: getValidJson(elementInfo.name).toString(),
        internalId: getValidJson(element.\@internalId).toString(),
        externalId: getValidJson(element.\@externalId).toString()
    };
    return recordRef;
}
