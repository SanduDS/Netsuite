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

//------------------------------------------------Create/Update Records-------------------------------------------------
function mapClassificationRecordFields(Classification classification) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error classificationMap = classification.cloneWithType(MapAnyData);
    if (classificationMap is map<anydata>) {
        string[] keys = classificationMap.keys();
        int position = 0;
        foreach var item in classification {
            if (item is string) {
                finalResult += setSimpleType(keys[position], item, LIST_ACCT);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }    
            position += 1;
        }
    }
    return finalResult;
}

function wrapClassificationElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="listAcct:Classification" 
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

function wrapClassificationElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="listAcct:Classification" internalId="${internalId}" 
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

function mapClassificationRecord(xml response) returns Classification|error {
    xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
    Classification 'class  = {
        name: (response/**/<listAcct:name>/*).toString(),
        includeChildren: check extractBooleanValueFromXMLOrText(response/**/<listAcct:includeChildren>/*),
        parent: {
            internalId: check response/**/<listAcct:parent>/*.internalId
        },
        isInactive: check extractBooleanValueFromXMLOrText(response/**/<listAcct:isInactive>/*),
        internalId: check response/**/<listAcct:internalId>/*.internalId
    };
    return 'class;
}

function getClassificationRecordGetOperationResult(http:Response response, RecordCoreType recordType) returns Classification|error{
    xml xmlValue = check formatPayload(response);
    if (response.statusCode == http:STATUS_OK) { 
        xml output  = xmlValue/**/<status>;
        boolean isSuccess = check extractBooleanValueFromXMLOrText(output.isSuccess);
        if(isSuccess) {
            return mapClassificationRecord(xmlValue);
        } else {
            fail error("No any record found");
        }
    } else {
        fail error("No any record found");
    }
}