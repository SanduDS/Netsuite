import ballerina/test;
import ballerina/log;
import ballerina/os;

configurable string accountId = os:getEnv("NS_ACCOUNTID");
configurable string consumerId = os:getEnv("NS_CLIENT_ID");
configurable string consumerSecret = os:getEnv("NS_CLIENT_SECRET");
configurable string token = os:getEnv("NS_TOKEN");
configurable string tokenSecret = os:getEnv("NS_TOKEN_SECRET");
configurable string baseURL = os:getEnv("NS_BASE_URL");

NetsuiteConfiguration config = {
    accountId: accountId,
    consumerId: consumerId,
    consumerSecret: consumerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL
};

Client netsuiteClient = check new (config);
string customerId = "";
string contactId ="";
string currencyId = "";
@test:Config {enable: true}
function testAddContactRecord() {
    log:print("testAddContactRecord");
    RecordRef cusForm = {
        internalId : "-40",
        'type: "customForm"
    };

    RecordRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    RecordRef category = {
        internalId : "12",
        'type: "category"
    };

    Address ad01 = {
        country: "_sriLanka",
        addr1: "Ruwanmaga",
        addr2:"Dodangoda",
        city:"Colombo",
        override: true
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2:"Dodangoda",
        city:"Colombo07",
        override: true
    };

    ContactAddressBook contactAddressBook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        addressBookAddress: [ad01]
    };
    
    ContactAddressBook contactAddressBook2 = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        addressBookAddress: [ad02]
    };

    Contact contact= {
        customForm :cusForm,
        firstName: "testaggst_041",
        middleName: "sandu",
        isPrivate: false,
        subsidiary: subsidiary,
        //categoryList:[category],
        globalSubscriptionStatus: "_confirmedOptIn",
        addressBookList : [contactAddressBook, contactAddressBook2]

    };
    RecordCreationInfo info = {
        instance: contact,
        recordType: CONTACT
    };
    RecordCreationResponse|error output = netsuiteClient->addNewRecord(info);
    if (output is RecordCreationResponse) {
        log:print(output.toString());
        contactId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}


@test:Config {enable: true}
function testAddCustomerRecord() {
    log:print("testAddCustomerRecord");
    RecordRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2:"Dodangoda",
        city:"Colombo07",
        override: true
    };

    RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    CustomerCurrency  cur = {
        currency:currency,
        balance: 1200.13,
        depositBalance: 10000,
        overdueBalance: 120,
        unbilledOrders: 1000,
        overrideCurrencyFormat: false
    };
    
    Customer customer= {
        entityId: "00d001s101",
        isPerson: true,
        salutation: "Mr",
        firstName: "Danu",
        middleName: "SK",
        lastName: "TestSilva",
        companyName: "Wso2",
        phone: "0756485071",
        fax: "0342287344",
        email: "sandusandu@wsoi2.com",
        subsidiary: subsidiary,
        //defaultAddress: "colobmbo7,Sri Lanka",
        isInactive: false,
        //category: "",
        title: "TestTilte",
        homePhone: "0348923456",
        mobilePhone: "3243243421",
        accountNumber: "ac9092328483",
        addressbookList: [customerAddressbook]
        //currencyList: [cur] currency is not added.

    };
    RecordCreationInfo info = {
        instance: customer,
        recordType: CUSTOMER
    };

    RecordCreationResponse|error output = netsuiteClient->addNewRecord(info);
    if (output is RecordCreationResponse) {
        log:print(output.toString());
        customerId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }

}

@test:Config {enable: true, dependsOn: [testAddCustomerRecord]}
function testupdateCustomerRecord() {
    log:print("testupdateCustomerRecord");
    RecordRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    Address ad02 = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2:"Dodangoda",
        city:"Colombo07",
        override: true
    };

    RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    CustomerCurrency  cur = {
        currency:currency,
        balance: 1200.13,
        depositBalance: 10000,
        overdueBalance: 120,
        unbilledOrders: 1000,
        overrideCurrencyFormat: false
    };
    
    Customer customer= {
        entityId: "00d001s101_test_Update",
        isPerson: true,
        salutation: "Mr",
        firstName: "Danushka",
        middleName: "Sandaruwan_Sri Lanka",
        lastName: "TestSilva",
        companyName: "Wso2",
        phone: "0756485071",
        fax: "0342287344",
        email: "sandusandu@wsoi2.com",
        subsidiary: subsidiary,
        //defaultAddress: "colobmbo7,Sri Lanka",
        isInactive: false,
        //category: "",
        title: "TestTilte",
        homePhone: "0348923456",
        mobilePhone: "3243243421",
        accountNumber: "ac9092328483",
        addressbookList: [customerAddressbook]
        //currencyList: [cur] currency is not added.

    };
    RecordUpdateInfo info = {
        instance: customer,
        internalId: customerId,
        recordType: CUSTOMER
    };

    RecordUpdateResponse|error output = netsuiteClient->updateRecord(info);
    if (output is RecordUpdateResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }

}

@test:Config {enable: true}
function testAddCurrencyRecord() {
    log:print("testAddCurrencyRecord");
    Currency currency = {
        name: "BLA",
        symbol: "BLA",
        //currencyPrecision: "_two",
        exchangeRate: 3.89,
        isInactive: false,
        isBaseCurrency: false
    };
    RecordCreationInfo info = {
        instance: currency,
        recordType: CURRENCY
    };

    RecordCreationResponse|error output = netsuiteClient->addNewRecord(info);
    if (output is RecordCreationResponse) {
        log:print(output.toString());
        currencyId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: false}
function testAddInvoiceRecord() {
    log:print("testAddInvoiceRecord");
    RecordRef entity = {
        name: "Ballerina Dummy Customer",
        internalId : "7933",
        'type: "entity"
    };
    Invoice invocie = {
        amountPaid: 10000,
        amountRemaining: 1500,
        balance: 8500,
        total: 12000,
        //email: "trst@wso2.com,                                                                                                                                                                                                                                                       ",
        status: "open",
        entity: entity
    };
   
    RecordCreationInfo info = {
        instance: invocie,
        recordType: INVOICE
    };

    RecordCreationResponse|error output = netsuiteClient->addNewRecord(info);
    if (output is RecordCreationResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.message());
    }
}
//SOAP WebService provides unexpected ERROR, But the record is added to the salesOrder list
@test:Config {enable: false}
function testSalesOrderRecord() {
    log:print("testSalesOrderRecord");
    RecordRef entity = {
        internalId : "4045",
        'type: "entity"
    };

    RecordRef itemValue = {
        internalId : "961",
        'type: "item"
    };
    Address address = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2:"Dodangoda",
        city:"Colombo07",
        override: true
    };
    RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    RecordRef location = {
        internalId : "23",
        'type: "location"
    };
    Item item = {
        item: itemValue,
        amount: 1,
        location: location
    };
    SalesOrder salesOrder = {
        entity:entity,
        billingAddress: address,
        currency: currency,
        itemList:[item]
    };
    RecordCreationInfo info = {
        instance: salesOrder,
        recordType: SALES_ORDER
    };
    RecordCreationResponse|error output = netsuiteClient->addNewRecord(info);
    if (output is RecordCreationResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.message());
    }

}

@test:Config {enable: true}
function testGetAll() {
    log:print("testGetAll");
    json[]|error output = netsuiteClient->getAll("currency");
    if (output is json[]) {
        log:print("Number of records found: " + output.length().toString());
    } else {
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: true}
function testGetSavedSearchFunction() {
    log:print("testGetSavedSearchFunction");
    json[]|error output = netsuiteClient->getSavedSearch("transaction");
    if (output is json[]) {
        log:print("Number of records found: " + output.length().toString());
    } else {
        test:assertFalse(false, output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddCustomerRecord, testAddCurrencyRecord, testAddContactRecord, 
testupdateCustomerRecord]}
function testDeleteRecord() {
    log:print("testCustomerDeleteRecord");
    RecordDeletionInfo recordDeletionInfo = {
        recordInternalId : customerId,
        recordType: "customer"
    };
    RecordDeletionResponse|error? output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else if (output is error){
        test:assertFail(output.toString());
    }
    log:print("testContactDeleteRecord");
    recordDeletionInfo = {
        recordInternalId : contactId,
        recordType: "contact"
    };
    output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else if (output is error){
        test:assertFail(output.toString());
    }
    log:print("testCurrencyDeleteRecord");
    recordDeletionInfo = {
        recordInternalId : currencyId,
        recordType: "currency"
    };
    output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else if (output is error){
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true}
function testSearch() {
    log:print("testSearch");
    SearchField searchRecord = {
        elementName: "companyName",
        operator: "is",
        value: "80 Acres"
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
    RecordSearchInfo info = {
        searchDetail: searchData,
        recordType: CUSTOMER_TYPE
    };
    //searchData.push(searchRecord2);
    json|error output = netsuiteClient->searchRecord(info);
    if (output is json) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(true, output.message());
    }
}
