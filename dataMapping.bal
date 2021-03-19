import ballerina/lang.'int as intLib;
import ballerina/lang.'decimal as decimalLib;

isolated function mapSavedSearchRespose(json responseBody) returns SavedSearchResult|error {
    int recordCount = 0;
    boolean isResponseSuccess = false;
    RecordRef[] recordRefListTemp = [];
    json|error resultArray = responseBody.soapenv_Body.getSavedSearchResponse.getSavedSearchResponse.
    platformCore_getSavedSearchResult.platformCore_getSavedSearchResult;
    if (resultArray is json) {
        json[] filteredJson = check verfiyPayload(resultArray);
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
    Invoice invoice = {};
    json|error resultArray = responseBody.soapenv_Body.getResponse.getResponse.readResponse.readResponse;
    if (resultArray is json) {
        json[] filteredJson = check verfiyPayload(resultArray);
        json|error status = filteredJson[0].platformCore_status.isSuccess;
        if (status is json) {
            if (status == "true") {
                isSuccessFlag = true;
            } else {
                fail error(status.toString());
            }
        }
        json|error result = filteredJson[1];
        if (result is json) {
            json|error recordType = result.xsi_type;
            if(recordType is json) {
                if(recordType.toString() == "tranSales_Invoice") {
                    json formattedValue = check formatCustomJsons(result, "\"record\":", "\"platformCore_record\":");
                    invoice = check mapInvoiceType(formattedValue);
                    json|error invoiceId = result.internalId;
                    if(invoiceId is json) {
                        invoice.invoiceId = invoiceId.toString();
                    }                 
                } else {
                    recordListTemp = result;
                }
            }           
        } else {
            fail error(result.toString());
        }
    }
    GetResponse result = {
        list: recordListTemp,
        isSuccess: isSuccessFlag,
        invoice: invoice
    };
    return result;
}

isolated function mapGetListRespose(json responseBody) returns GetListResponse|error {
    boolean isSuccessFlag = false;
    json[] recordListTemp = [];
    json|error resultArray = responseBody.soapenv_Body.getListResponse.getListResponse.readResponseList.readResponseList;
    if (resultArray is json) {
        json[] filteredJson = check verfiyPayload(resultArray);
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
            if (result is json) {
                recordListTemp.push(result);
            } else {
                fail error(result.toString());
            }
        }
    }
    GetListResponse result = {
        list: recordListTemp,
        isSuccess: isSuccessFlag
    };
    return result;
}

isolated function mapTranscationRespose(json responseBody) returns TrasactionSearchResponse|error {
    boolean isSuccessFlag = false;
    json[] recordListTemp = [];
    Invoice[] invoicesListTemp = []; 
    json|error resultArray = responseBody.soapenv_Body.searchResponse.searchResponse.platformCore_searchResult.
    platformCore_searchResult;
    if (resultArray is json) {
        json[] filteredJson = check verfiyPayload(resultArray);
        json|error status = filteredJson[0].platformCore_status.isSuccess;
        if (status is json) {
            if (status == "true") {
                isSuccessFlag = true;
            } else {
                fail error(status.toString());
            }
        }
        int index = filteredJson.length() - 1;
        json|error recordList = filteredJson[index].platformCore_recordList;
        if (recordList is json) {
            json[] filteredRecordList = <json[]>recordList;
            foreach json item in filteredRecordList {
                json|error Itemtype = item.xsi_type;
                if(Itemtype is json) {
                    if (Itemtype.toString() == "tranSales_Invoice") {
                        Invoice invoice = check mapInvoiceType(item);
                        json|error InvoiceID = item.internalId;
                        if(InvoiceID is json) {
                            invoice.invoiceId = InvoiceID.toString();
                        }
                        invoicesListTemp.push(invoice);
                    } else {
                        recordListTemp.push(item);
                    }
                } else {
                    fail error(Itemtype.toString());
                }
            }

        }
    }
    TrasactionSearchResponse transcationResults =  {
        invoices :invoicesListTemp,
        payload : recordListTemp,
        isSuccess : isSuccessFlag
    };
    return transcationResults;
}

isolated function mapInvoiceType(json item) returns Invoice|error {
    Invoice invoice = {};
    json|error rawRecordType = item.platformCore_record;
    if (rawRecordType is json) {
        json[] recordData = check verfiyPayload(rawRecordType);
        foreach json value in recordData {
            map<json> jsonMap = <map<json>>value;
            if (jsonMap.hasKey("tranSales_amountPaid")) {
                invoice.amountPaid = check decimalLib:fromString(jsonMap.get("tranSales_amountPaid").toString());
            }
            if (jsonMap.hasKey("tranSales_amountRemaining")){
                invoice.amountRemaining = check decimalLib:fromString(jsonMap.get("tranSales_amountRemaining")
                .toString());
            }
            if (jsonMap.hasKey("tranSales_balance")) {
                invoice.balance = check decimalLib:fromString(jsonMap.get("tranSales_balance").toString());
            }
            if (jsonMap.hasKey("tranSales_total")) {
                invoice.total = check decimalLib:fromString(jsonMap.get("tranSales_total").toString());
            }
            if (jsonMap.hasKey("tranSales_entity")) {
                json|error name = jsonMap.get("tranSales_entity").platformCore_name.platformCore_name;
                if(name is json) {
                   invoice.entity = name.toString(); 
                }
                name = jsonMap.get("internalId");
                if(name is json) {
                   invoice.entityInternalId = name.toString(); 
                }
            }
            if (jsonMap.hasKey("tranSales_createdDate")) {
                invoice.createdDate = jsonMap.get("tranSales_createdDate").toString();
            }
            if (jsonMap.hasKey("tranSales_currencyName")) {
                invoice.currencyName = jsonMap.get("tranSales_currencyName").toString();
            }
            if (jsonMap.hasKey("tranSales_dueDate")) {
                invoice.dueDate = jsonMap.get("tranSales_dueDate").toString();
            }
            if (jsonMap.hasKey("tranSales_email")) {
                invoice.email = jsonMap.get("tranSales_email").toString();
            }
            if (jsonMap.hasKey("tranSales_lastModifiedDate")) {
                invoice.lastModifiedDate = jsonMap.get("tranSales_lastModifiedDate").toString();
            }
            if (jsonMap.hasKey("tranSales_status")) {
                invoice.status = jsonMap.get("tranSales_status").toString();
            }
            if (jsonMap.hasKey("tranSales_tranId")) {
                invoice.transactionId = jsonMap.get("tranSales_tranId").toString();
            }
        }
        return invoice;
    } else {
        fail error("Error in Invoice Parsing");
    }
}

isolated function verfiyPayload(json payload) returns json[]|error {
    json[]|error recordData = trap <json[]>payload;
    if (recordData is json[]) {
       return recordData;
    } else {
        fail error(payload.toString());
    }
}
