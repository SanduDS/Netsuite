import ballerina/log;
import ballerina/regex;
import ballerina/lang.'xml as xmlLib;
import ballerina/jsonutils;
import ballerina/http;

xmlns "urn:accounting_2020_2.lists.webservices.netsuite.com" as listAcct;
//these functions are still being developed.
function formatAddResponse(http:Response response) returns AddRecordResponse|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        //log:print(xmlValure.toString());
        //string element = string `soapenv_Body`;
        xml output  = xmlValure/**/<platformCore_status>;
        json  afterSubmissionResponse= check jsonutils:fromXML(xmlValure/**/<platformCore_afterSubmitFailed>);
        //log:print(afterSubmissionResponse.toString());
        string isSuccess = check output.isSuccess;
        log:print("isSucces " + isSuccess);
        if(isSuccess == "true" && afterSubmissionResponse.platformCore_afterSubmitFailed == "false" ) {
            xml baseRef  = xmlValure/**/<baseRef>;
            AddRecordResponse addResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return addResponse;
            //log:print(xmlValure.toString());
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<platformCore_statusDetail>);
            fail error(errorMessage.toString());
            //log:print(xx.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatDeleteResponse(http:Response response) returns DeleteRecordResponse|error {
    xml xmlValure = check formatPayload(response);
    //log:print("responsecode" + response.statusCode.toString()+"\n"+ formattedXMLResponse);
    if (response.statusCode == 200) {
        //log:print(xmlValure.toString());
        //string element = string `soapenv_Body`;
        xml output  = xmlValure/**/<platformCore_status>;
        //json  afterSubmissionResponse= check jsonutils:fromXML(xmlValure/**/<platformCore_afterSubmitFailed>);
        //log:print(afterSubmissionResponse.toString());
        string isSuccess = check output.isSuccess;
        log:print("isSucces " + isSuccess);
        if(isSuccess == "true") {
            xml baseRef  = xmlValure/**/<baseRef>;
            DeleteRecordResponse deleteResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return deleteResponse;
            //log:print(xmlValure.toString());
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<platformCore_statusDetail>);
            fail error(errorMessage.toString());
            //log:print(xx.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatUpdateResponse(http:Response response) returns UpdateRecordResponse|error {
    xml xmlValure = check formatPayload(response);
    //log:print("responsecode" + response.statusCode.toString()+"\n"+ formattedXMLResponse);
    if (response.statusCode == 200) {
        //log:print(xmlValure.toString());
        //string element = string `soapenv_Body`;
        xml output  = xmlValure/**/<platformCore_status>;
        //json  afterSubmissionResponse= check jsonutils:fromXML(xmlValure/**/<platformCore_afterSubmitFailed>);
        //log:print(afterSubmissionResponse.toString());
        string isSuccess = check output.isSuccess;
        log:print("isSucces " + isSuccess);
        if(isSuccess == "true") {
            xml baseRef  = xmlValure/**/<baseRef>;
            UpdateRecordResponse updateResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return updateResponse;
            //log:print(xmlValure.toString());
        } else {
            json errorMessage= check jsonutils:fromXML(xmlValure/**/<platformCore_statusDetail>);
            fail error(errorMessage.toString());
            //log:print(xx.toString());
        }    
    } else {
        fail error(xmlValure.toString());
    }
}

function formatGetAllResponse(http:Response response) returns json[]|error {
    xml xmlValure = check formatPayload(response);
    if (response.statusCode == 200) {
        xml output  = xmlValure/**/<platformCore_status>;
        string isSuccess = check output.isSuccess;
        log:print("isSucces " + isSuccess);
        if(isSuccess == "true") {
            xml:Element records = <xml:Element> xmlValure/**/<platformCore_recordList>;
            xml baseRef  = xmlLib:getChildren(records);
            json[] recordList = [];
            var xx = xmlLib:forEach(baseRef,function(xml platformCore_record) {
                string|error count =  platformCore_record.xsi_type;
                if(count is string ) {
                    match count {
                        "listAcct:Currency" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCore_record, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }
                        }
                        "listAcct:budgetCategory" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCore_record, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }
                        "listMkt:campaignAudience" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCore_record, "listMkt:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }
                        "listAcct:taxAcct" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCore_record, "listAcct:");
                            json|error  afterSubmissionResponse = jsonutils:fromXML(recordItems/*);
                            if(afterSubmissionResponse is json) {
                                recordList.push(afterSubmissionResponse);
                            }  
                        }
                        "listRel:state" => {
                            xml recordItems = checkpanic replaceRegexInXML(platformCore_record, " listRel:");
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
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, "platformCore:", "platformCore_");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse, "platformMsgs:", "platformMsgs_");
    string regex01 = string `xmlns="urn:messages_2020_2.platform.webservices.netsuite.com"`;
    string regex02 = string `xmlns:platformCore="urn:core_2020_2.platform.webservices.netsuite.com"`;
    string regex03 = string `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`;
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse,regex01,"");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse,regex02,"");
    formattedXMLResponse = regex:replaceAll(formattedXMLResponse,regex03,"");
    return check xmlLib:fromString(formattedXMLResponse);
}

