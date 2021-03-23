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
function testGetList() returns error? {
    log:print("testGetList");
    GetListRequestField requestList = {
        internalId:  "86912", 
        recordType: "invoice"
    };
    GetListRequestField requestList1 = {
        internalId:  "1020", 
        recordType: "customer"
    };
    GetListRequestField[] arrylist = [requestList];
    GetListResponse|error output = netsuiteClient->getList(arrylist);
    if (output is GetListResponse) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: false}
function testGetSavedSearchFunction() {
    log:print("testGetSavedSearchFunction");
    SavedSearchResult|error output = netsuiteClient->getSavedSearch("transaction");
    if (output is SavedSearchResult) {
        log:print(output.recordRefList[0].toString());
    } else {
        log:printError(output.message());
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: false}
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
    date : "2020-12-23T10:20:15",
    date2 : "2021-03-23T10:20:15"
    };
    SearchField searchRecord = {
        elementName : "lastModifiedDate",
        operator : "within",
        dateField : date
    };
    SearchField searchRecord2 = {
        //elementName : "paymentOption",
        operator : "anyOf",
        value : "_invoice"
    };
    
    SearchField[] searchData = [];
    searchData.push(searchRecord);
    searchData.push(searchRecord2);
    TrasactionSearchResponse|error output = netsuiteClient->transactionSearch(searchData);
    if (output is TrasactionSearchResponse) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: false}
function testGet() {
    GetRequestField request = {
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
