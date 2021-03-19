import ballerina/lang.'int as intLib;

isolated function mapSavedSearchRespose(json responseBody) returns SavedSearchResult|error {
    int recordCount = 0;
    boolean isResponseSuccess = false;
    RecordRef[] recordRefListTemp = [];
    json|error resultArray = responseBody.soapenv_Body.getSavedSearchResponse.getSavedSearchResponse.
    platformCore_getSavedSearchResult.platformCore_getSavedSearchResult;
    if (resultArray is json) {
        json[] filteredJson = <json[]>resultArray;
        //log:print(filteredJson.toString());
        json|error status = filteredJson[0].platformCore_status.isSuccess;
        if (status is json) {
            if (status == "true") {
                isResponseSuccess = true;
            }
        }
        json|error count = filteredJson[1].platformCore_totalRecords;
        if (count is json) {
            recordCount = checkpanic intLib:fromString(count.toString());
        }
        json|error records = filteredJson[2].platformCore_recordRefList;
        if (records is json) {
            json[] resultList = <json[]>records;
            foreach json item in resultList {
                json|error itemName = item.platformCore_recordRef.platformCore_name.platformCore_name;
                json|error scId = item.scriptId;
                json|error inId = item.internalId;
                if (itemName is json && scId is json && inId is json) {
                    RecordRef recordItem = {
                        name: itemName.toString(),
                        scriptId: scId.toString(),
                        internalId: inId.toString()
                    };
                    recordRefListTemp.push(recordItem);
                }
            }
        }
    }
    SavedSearchResult result = {
        numberOfRecords: recordCount,
        isSuccess: isResponseSuccess,
        recordRefList: recordRefListTemp
    };
    return result;
}

isolated function mapGetRespose(json responseBody) returns GetResponse|error {
    boolean isSuccessFlag = false;
    json recordListTemp = "";
    json|error resultArray = responseBody.soapenv_Body.getResponse.getResponse.readResponse.readResponse;
    if (resultArray is json) {
        json[] filteredJson = <json[]>resultArray;
        json|error status = filteredJson[0].platformCore_status.isSuccess;
        if (status is json) {
            if (status == "true") {
                isSuccessFlag = true;
            } else {
                fail error(status.toString());
            }
        }
        json|error result = filteredJson[1];
        if(result is json) {
            recordListTemp = result;
        } else {
            fail error(result.toString());
        }     
    }
    GetResponse result = {
        list : recordListTemp,
        isSuccess: isSuccessFlag
    };
    return result;
}

isolated function mapGetListRespose(json responseBody) returns GetListResponse|error {
    boolean isSuccessFlag = false;
    json[] recordListTemp = [];
    json|error resultArray = responseBody.soapenv_Body.getListResponse.getListResponse.readResponseList.readResponseList;
    if (resultArray is json) {
        json[] filteredJson = <json[]>resultArray;
        json|error status = filteredJson[0].platformCore_status.isSuccess;
        if (status is json) {
            if (status == "true") {
                isSuccessFlag = true;
            } else {
                fail error(status.toString());
            }
        }
        int length = filteredJson.length() - 1;
        foreach int i in 1 ... length {
            json|error result = filteredJson[i].readResponse;
            if(result is json) {
                recordListTemp.push(result);
            } else {
                fail error(result.toString());
            }
        }  
    }
    GetListResponse result = {
        list : recordListTemp,
        isSuccess: isSuccessFlag
    };
    return result;
}