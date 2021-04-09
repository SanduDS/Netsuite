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

import ballerina/regex;
import ballerina/lang.'xml as xmlLib;
import ballerina/jsonutils;
import ballerina/http;

function formatInstanceCreationResponse(http:Response response) returns RecordCreationResponse|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<status>;
        json  afterSubmissionResponse= check jsonutils:fromXML(xmlValure/**/<afterSubmitFailed>);
        string isSuccess = check output.isSuccess;
        if(isSuccess == "true" && afterSubmissionResponse.afterSubmitFailed == "false" ) {
            xml baseRef  = xmlValure/**/<baseRef>;
            RecordCreationResponse instanceCreationResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return instanceCreationResponse;
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatDeleteResponse(http:Response response) returns RecordDeletionResponse|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<status>;
        string isSuccess = check output.isSuccess;
        if(isSuccess == "true") {
            xml baseRef  = xmlValure/**/<baseRef>;
            RecordDeletionResponse deleteResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return deleteResponse;
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatUpdateResponse(http:Response response) returns RecordUpdateResponse|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<status>;
        string isSuccess = check output.isSuccess;
        if(isSuccess == "true") {
            xml baseRef  = xmlValure/**/<baseRef>;
            RecordUpdateResponse updateResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return updateResponse;
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatGetAllResponse(http:Response response) returns json[]|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<status>;
        string isSuccess = check output.isSuccess;
        if(isSuccess == "true") {
            xml:Element records = <xml:Element> xmlValure/**/<recordList>;
            xml baseRef  = xmlLib:getChildren(records);
            json[] recordList = [];
            var xx = xmlLib:forEach(baseRef,function(xml platformCoreRecord) {
                string|error count =  platformCoreRecord.xsi_type;
                if(count is string ) {
                    match count {
                        "listAcct:Currency" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }
                        }
                        "listAcct:budgetCategory" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }
                        "listMkt:campaignAudience" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, "listMkt:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }
                        "listAcct:taxAcct" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }
                        "listRel:state" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, " listRel:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }

                    }
                }
            });
             
            return recordList;
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<platformCore_statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function replaceRegexInXML(xml value, string regex, string replacement = "") returns xml|error {
    string formattedXMLResponse = regex:replaceAll(value.toString(), regex, replacement);
    return check xmlLib:fromString(formattedXMLResponse);
} 

function formatPayload(http:Response response) returns xml|error {
    xml xmlValure  = check response.getXmlPayload();
    string formattedXMLResponse = regex:replaceAll(xmlValure.toString(), "soapenv:", "soapenv_");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, "xsi:", "xsi_");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, "platformCore:", "");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, "platformMsgs:", "platformMsgs_");
    string regex01 = string `xmlns="urn:messages_2020_2.platform.webservices.netsuite.com"`;
    string regex02 = string `xmlns:platformCore="urn:core_2020_2.platform.webservices.netsuite.com"`;
    string regex03 = string `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`;
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse,regex01,"");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse,regex02,"");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse,regex03,"");
    return check xmlLib:fromString(formattedXMLResponse);
}

function formatSavedSearchResponse(http:Response response) returns json[]|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<status>;
        string isSuccess = check output.isSuccess;
        if(isSuccess == "true") {
            xml:Element records = <xml:Element> xmlValure/**/<recordRefList>;
            xml baseRef  = xmlLib:getChildren(records);
            json[] recordList = [];
            var xx = xmlLib:forEach(baseRef,function(xml platformCoreRecord) {
                string|error count =  platformCoreRecord.xsi_type;
                if(count is string ) {
                    match count {
                        "CustomizationRef" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }
                        }
                    }
                }
            });          
            return recordList;
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatSearchResponse(http:Response response) returns json|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<status>;
        string isSuccess = check output.isSuccess;
        if(isSuccess == "true") {
            xml:Element records = <xml:Element> xmlValure/**/<recordList>;
            xml baseRef  = xmlLib:getChildren(records);
            json searchResults = [];
            var xx = xmlLib:forEach(baseRef,function(xml platformCoreRecord) {
                string|error count =  platformCoreRecord.xsi_type;
                if(count is string ) {
                    match count {
                        "listRel:Customer" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCoreRecord, "listRel:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                searchResults = afterSubmissionResponse;
                            }
                        }
                    }
                }
            });          
            return searchResults;
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<statusDetail>);
            fail error(errorMessage.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}


