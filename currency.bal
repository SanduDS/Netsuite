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
xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;

//------------------------------------------------Create/Update Records-------------------------------------------------
function mapCurrencyRecordFields(Currency currency) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error currencyMap = currency.cloneWithType(MapAnyData);
    if (currencyMap is map<anydata>) {
        string[] keys = currencyMap.keys();
        int position = 0;
        foreach var item in currency {
            if (item is string|boolean|decimal|int) {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            }
            position += 1;
        }
    }
    return finalResult;
}

function wrapCurrencyElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="listAcct:Currency" 
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

function wrapCurrencyElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="listAcct:Currency" internalId="${internalId}"
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

function mapCurrencyRecord(xml response) returns Currency|error {
    Currency currency  = {
        name: (response/**/<listAcct:name>/*).toString(),
        symbol: (response/**/<listAcct:symbol>/*).toString(),
        currencyPrecision:  (response/**/<listAcct:currencyPrecision>/*).toString(),
        isInactive: check extractBooleanValueFromXMLOrText(response/**/<listAcct:isInactive>/*),
        isBaseCurrency: check extractBooleanValueFromXMLOrText(response/**/<listAcct:isInactive>/*)
    };
    return currency;
}

function getCurrencyRecordGetOperationResult(http:Response response, RecordCoreType recordType) returns Currency|error{
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapCurrencyRecord(xmlValue);
        } else {
            fail error("No any record found");
        }
    } else {
        fail error("No any record found");
    }
}
 
