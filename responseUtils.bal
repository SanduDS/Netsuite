//import ballerina/log;
import ballerina/regex;
import ballerina/lang.'xml as xmlLib;
import ballerina/jsonutils;
import ballerina/http;

# Description
#
# + rawResponse - Parameter Description
# + return - Return Value Description  
function formatAddResponse(http:Response response) returns AddRecordResponse|error {
    
    xml xmlValure  = check response.getXmlPayload();
    string stepOne = regex:replaceAll(xmlValure.toString(), "soapenv:", "soapenv_");
    stepOne = regex:replaceAll(stepOne, "xsi:", "xsi_");
    stepOne = regex:replaceAll(stepOne, "platformCore:", "platformCore_");
    stepOne = regex:replaceAll(stepOne, "platformMsgs:", "platformMsgs_");
    string regex1 = string `xmlns="urn:messages_2020_2.platform.webservices.netsuite.com"`;
    string regex102 = string `xmlns:platformCore="urn:core_2020_2.platform.webservices.netsuite.com"`;
    string regex103 = string `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`;
    string st01 = regex:replaceAll(stepOne,regex1,"");
    st01 = regex:replaceAll(st01,regex102,"");
    st01 = regex:replaceAll(st01,regex103,"");
    xml raw = check xmlLib:fromString(st01);
    //log:print("responsecode" + response.statusCode.toString());
    if (response.statusCode == 200) {
        //log:print(raw.toString());
        //string element = string `soapenv_Body`;
        xml output  = raw/**/<platformCore_status>;
        xml afterSubmitedFailed = raw/**/<platformCore_afterSubmitFailed>;
        string isSuccess = check output.isSuccess;
        //log:print("issucces " + isSuccess);
        if(isSuccess == "true" && afterSubmitedFailed.toString() == "false" ) {
            xml baseRef  = raw/**/<baseRef>;
            AddRecordResponse addResponse = {
                isSuccess: true,
                internalId: check baseRef.internalId,
                recordType: check baseRef.'type
            };
            return addResponse;
            //log:print(raw.toString());
        } else {
            json errorMessage= checkpanic jsonutils:fromXML(raw/**/<platformCore_statusDetail>);
            fail error(errorMessage.toString());
            //log:print(xx.toString());
        }
        
    } else {
        fail error(raw.toString());
    }
}