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
xmlns "urn:sales_2020_2.transactions.webservices.netsuite.com" as tranSales;
//------------------------------------------------Create/Update Records-------------------------------------------------
function mapInvoiceRecordFields(Invoice invoice) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error invoiceMap = invoice.cloneWithType(MapAnyData);
    if (invoiceMap is map<anydata>) {
        string[] keys = invoiceMap.keys();
        int position = 0;
        foreach var item in invoice {
            if (item is string|decimal) {
                finalResult += setSimpleType(keys[position], item, TRAN_SALES);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }    
            position += 1;
        }
    }
    return finalResult;
}

function wrapInvoiceElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="tranSales:Invoice" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

function wrapInvoiceElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="tranSales:Invoice" internalId="${internalId}"
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

function mapInvoiceRecord(xml response) returns Invoice|error {
    Invoice invoice  = {
        ///amountPaid: check decimalLib:fromString((response/**/<tranSales:amountPaid>/*).toString()),
        //balance: check decimalLib:fromString((response/**/<tranSales:balance>/*).toString()),
        total: check decimalLib:fromString((response/**/<tranSales:total>/*).toString()),
        createdDate: (response/**/<tranSales:total>/*).toString(),
        currencyName: (response/**/<tranSales:currencyName>/*).toString(),
        lastModifiedDate: (response/**/<tranSales:createdDate>/*).toString(),
        dueDate: (response/**/<tranSales:dueDate>/*).toString(),
        status: (response/**/<tranSales:status>/*).toString(),
        transactionId: (response/**/<tranSales:transactionId>/*).toString(),
        entity: {
            internalId: (check response/**/<tranSales:entity>.internalId)
        },
        invoiceId: check response/**/<tranSales:'record>.internalId
    };
    return invoice;
}

function getInvoiceRecordGetOperationResult(http:Response response, RecordCoreType recordType) returns Invoice|error{
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
