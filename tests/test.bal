import ballerina/test;
import ballerina/log;

configurable string accountId = ?;
configurable string consumerId = ?;
configurable string consmerSecret = ?;
configurable string token = ?;
configurable string tokenSecret = ?;
configurable string baseURL = ?;

NetsuiteConfiguration config = {
    accountId: accountId,
    consumerId: consumerId,
    consmerSecret: consmerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL
};

Client netsuiteClient = checkpanic new (config);

@test:Config {enable: true}
function testGetAll() {
    log:print("testGetAll");
    json|error output = netsuiteClient->getAll("currency");
    if (output is json) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: true}
function testGetList() {
    log:print("testGetList");
    GetListReqestFeild requestList = {
        internalId:  "1020", 
        recordType: "customer"
    };
    GetListReqestFeild requestList1 = {
        internalId:  "1020", 
        recordType: "customer"
    };
    GetListReqestFeild[] arrylist = [requestList, requestList1];
    GetListResponse|error output = netsuiteClient->getList(arrylist);
    if (output is GetListResponse) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true}
function testGetSavedSearchFunction() {
    log:print("testGetSavedSearchFunction");
    SavedSearchResult|error output = netsuiteClient->getSavedSearch("vendor");
    if (output is SavedSearchResult) {
        log:print(output.recordRefList[0].toString());
    } else {
        log:printError(output.message());
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: true}
function testSearch() {
    log:print("testSearch");
    SearchField searchRecord = {
        elementName: "email",
        operator: "is",
        value: "ShanU@99x.lk"
    };
    SearchField searchRecord2 = {
        elementName: "currency",
        operator: ANYOF,
        value: "",
        internalId:"1",
        externalId: ""
    };
    SearchField[] searchData = [];
    searchData.push(searchRecord);
    searchData.push(searchRecord2);
    json|error output = netsuiteClient->customerSearch(searchData);
    if (output is json) {
        log:print(output.toString());

    } else {
        log:printError(output.toString());
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true}
function testTransactionSearch() {
    log:print("testTransactionSearch");
    DateField date = {
    operator :"within" ,
    date : "2021-01-23T10:20:15",
    date2 : "2021-02-23T10:20:15"
    };
    SearchField searchRecord = {
        elementName : "lastModifiedDate",
        operator : AFTER,
        dateField : date
    };
    SearchField searchRecord2 = {
        elementName : "paymentOption",
        operator : CONTAINS,
        value : "Invoice"
    };
    SearchField[] searchData = [];
    searchData.push(searchRecord);
    searchData.push(searchRecord2);
    json|error output = netsuiteClient->transactionSearch(searchData);
    if (output is json) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: true}
function testGet() {
    GetReqestFeild request = {
        internalId:  "1020", 
        recordType: "customer"
    };     
    GetResponse|error output = netsuiteClient->get(request);
    if (output is GetResponse) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(true, output.message());
    }
}

