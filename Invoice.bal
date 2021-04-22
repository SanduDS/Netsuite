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
import ballerina/lang.'decimal as decimalLib;
import ballerina/lang.'xml as xmlLib;

//------------------------------------------------Create/Update Records-------------------------------------------------
isolated function mapInvoiceRecordFields(Invoice invoice) returns string|error {
    string finalResult = EMPTY_STRING;
    map<anydata>|error invoiceMap = invoice.cloneWithType(MapAnyData);
    if (invoiceMap is map<anydata>) {
        string[] keys = invoiceMap.keys();
        int position = 0;
        foreach var invoiceField in invoice {
            if (invoiceField is string|decimal) {
                finalResult += setSimpleType(keys[position], invoiceField, TRAN_SALES);
            } else if (invoiceField is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>invoiceField);
            } else if (invoiceField is Item[]) {
                string itemXMLList = EMPTY_STRING;
                foreach Item item in invoiceField {
                    string itemElements = check buildInvoiceItemElement(item);
                    itemXMLList += itemElements;
                }
                finalResult += string`<itemList>${itemXMLList}</itemList>`;  
            } 
            position += 1;
        }
    }
    return finalResult;
}

isolated function buildInvoiceItemElement(Item item) returns string|error {
    string itemElements = EMPTY_STRING;
    map<anydata> itemMap = check item.cloneWithType(MapAnyData);
    string[] keys = itemMap.keys();
    int position = 0;
    foreach var itemField in item {
        if(itemField is RecordRef) {
            itemElements += getXMLRecordRef(<RecordRef>itemField);
        }else if (itemField is string|boolean|decimal) {
            itemElements += setSimpleType(keys[position], itemField, TRAN_SALES);
        }
        position += 1;
    }
    return string`<item>${itemElements}</item>`;
}

isolated function wrapInvoiceElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="tranSales:Invoice" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function wrapInvoiceElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="tranSales:Invoice" internalId="${internalId}"
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

isolated function mapInvoiceRecord(xml response) returns Invoice|error {
    xmlns "urn:sales_2020_2.transactions.webservices.netsuite.com" as tranSales;
    Invoice invoice  = {
        discountTotal: check decimalLib:fromString((response/**/<tranSales:discountTotal>/*).toString()),
        recognizedRevenue: check decimalLib:fromString((response/**/<tranSales:recognizedRevenue>/*).toString()),
        deferredRevenue: check decimalLib:fromString((response/**/<tranSales:deferredRevenue>/*).toString()),
        subsidiary: {
            internalId: (check response/**/<tranSales:subsidiary>.internalId),
            name: (response/**/<tranSales:subsidiary>/<name>/*).toString()
        },
        classification: {
            internalId: (check response/**/<tranSales:'class>.internalId),
            name: (response/**/<tranSales:'class>/<name>/*).toString()
        },
        total: check decimalLib:fromString((response/**/<tranSales:total>/*).toString()),
        department: {
            internalId: (check response/**/<tranSales:department>.internalId),
            name: (response/**/<tranSales:department>/<name>/*).toString()
        },
        createdDate: (response/**/<tranSales:createdDate>/*).toString(),
        lastModifiedDate: (response/**/<tranSales:createdDate>/*).toString(),
        status: (response/**/<tranSales:status>/*).toString(),
        entity: {
            internalId: (check response/**/<tranSales:entity>.internalId),
            name: (response/**/<tranSales:entity>/<name>/*).toString()
        },
        currency: {
            internalId: (check response/**/<tranSales:currency>.internalId),
            name: (response/**/<tranSales:currency>/<name>/*).toString()
        },
        internalId: check response/**/<'record>.internalId
    };
    return invoice;
}

isolated function getInvoiceRecordGetOperationResult(http:Response response, RecordCoreType recordType) returns Invoice|error {
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapInvoiceRecord(xmlValue);
        } else {
            fail error("No any record found");
        }
    } else {
        fail error("No any record found");
    }
}

//------------------------------------search functions------------------------------------------------------------------
///////////////////////////////////Transactions/////////////////////////////////////////////////////////////////////////
isolated function buildTransactionSearchPayload(NetSuiteConfiguration config, SearchElement[] searchElement) returns 
                                                xml|error {
    string requestHeader = check buildXMLPayloadHeader(config);
    string requestBody = getTranscationSearchRequestBody(searchElement);
    return check getSoapPayload(requestHeader, requestBody); 
}

isolated function getTranscationSearchRequestBody(SearchElement[] SearchElements) returns string{
    return string `<soapenv:Body><search xmlns="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <searchRecord xsi:type="ns1:TransactionSearchBasic" xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">
    ${getSearchElement(SearchElements)}
    </searchRecord>
    </search></soapenv:Body>
    </soapenv:Envelope>`;
}

isolated function getTransactionSearchResult(http:Response response) returns RecordList|error {
    xmlns "urn:sales_2020_2.transactions.webservices.netsuite.com" as tranSales;
    xml xmlValue = check response.getXmlPayload();
    if(response.statusCode == http:STATUS_OK) {
        xmlValue = check formatPayload(response);
        string|error successStatus = xmlValue/**/<status>.isSuccess;
        if(successStatus is error) {
            fail error(xmlValue.toString());
        }
        boolean|error isSuccess = extractBooleanValueFromXMLOrText(successStatus);
        if(isSuccess is error) {
            fail error("Error in search results");
        } else {
            if(isSuccess == true) {
                xml recordList = xmlValue/**/<recordList>/*;
                int size = recordList.length();
                RecordRef[] recordRefList =[];
                foreach int i in 0 ..< size {
                    xml recordItem = xmlLib:get(recordList, i);
                    RecordRef recordRef = {
                        internalId: check recordItem/**/<'record>.internalId,
                        'type: check recordItem/**/<'record>.xsi_type
                    };
                    recordRefList.push(recordRef);  
                }
                RecordList recordSet = {
                        records: recordRefList
                };
                return recordSet;
            } else {
                fail error("Search was not successful in Netsuite");
            }
        }
    } else {
        fail error(xmlValue.toString());
    }
    
}
