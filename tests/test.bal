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

import ballerina/test;
import ballerina/log;
import ballerina/os;

configurable string accountId = os:getEnv("NS_ACCOUNTID");
configurable string consumerId = os:getEnv("NS_CLIENT_ID");
configurable string consumerSecret = os:getEnv("NS_CLIENT_SECRET");
configurable string token = os:getEnv("NS_TOKEN");
configurable string tokenSecret = os:getEnv("NS_TOKEN_SECRET");
configurable string baseURL = os:getEnv("NS_BASE_URL");

NetSuiteConfiguration config = {
    accountId: accountId,
    consumerId: consumerId,
    consumerSecret: consumerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL
};

Client netsuiteClient = check new (config);
string customerId = EMPTY_STRING;
string contactId =EMPTY_STRING;
string currencyId = EMPTY_STRING;
string salesOrderId = EMPTY_STRING;
string classificationId = EMPTY_STRING;
string customerAccountId = EMPTY_STRING;
string invoiceId = EMPTY_STRING;

//----------------------------------------------------- Beginning of Record Addition Tests------------------------------
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
        firstName: "testContact_01",
        middleName: "sandu",
        isPrivate: false,
        subsidiary: subsidiary,
        //categoryList:[category],
        globalSubscriptionStatus: "_confirmedOptIn",
        addressBookList : [contactAddressBook, contactAddressBook2]

    };
    RecordAddResponse|error output = netsuiteClient->addNewContact(contact);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        contactId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}


@test:Config {enable: true}
function testAddNewCustomerRecord() {
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
        entityId: "BallerinaTest01",
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
        //category: EMPTY_STRING,
        title: "TestTilte",
        homePhone: "0348923456",
        mobilePhone: "3243243421",
        accountNumber: "ac9092328483",
        addressbookList: [customerAddressbook]
        //currencyList: [cur] currency is not added.

    };
    RecordAddResponse|error output = netsuiteClient->addNewCustomer(customer);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        customerId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
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
    RecordAddResponse|error output = netsuiteClient->addNewCurrency(currency);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        currencyId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddInvoiceRecord() {
    log:print("testAddInvoiceRecord");
    RecordRef entity = {
        internalId : "5530",
        'type: "entity"
    };
    Item item01 = {
        item: {
            internalId: "560",
            'type: "item"
         },
        amount: 1000
    };

    Item item02 = {
        item: {
            internalId: "570",
            'type: "item"
         },
        amount: 2000
    };
    Invoice invoice = {
        entity: entity,
        itemList: [item01, item02]
    };
    RecordAddResponse|error output = netsuiteClient->addNewInvoice(invoice);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        invoiceId = output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testSalesOrderAddOperation() {
    log:print("testSalesOrderRecordOperation");
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
        amount: 100,
        location: location
    };
    SalesOrder salesOrder = {
        entity:entity,
        billingAddress: address,
        currency: currency,
        itemList:[item]
    };
    RecordAddResponse|error output = netsuiteClient->addNewSalesOrder(salesOrder);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        salesOrderId = output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddClassificationRecord() {
    log:print("testAddClassificationRecord");
    RecordRef recordRef = {
        internalId: "10",
        'type: "parent"
    };
    Classification classification = {
        name:"Ballerina test class",
        parent: recordRef
    };
    RecordAddResponse|error output = netsuiteClient->addNewClassification(classification);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        classificationId = <@untainted>output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true}
function testAddAccountRecord() {
    log:print("testAddAccountRecord");
    RecordRef currency = {
        internalId: "1",
        'type: "currency"
    };
    Account account = {
        acctNumber: "67425630",
        acctName: "Ballerina test account",
        currency: currency
    };
    RecordAddResponse|error output = netsuiteClient->addNewAccount(account);
    if (output is RecordAddResponse) {
        log:print(output.toString());
        customerAccountId = output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

 //----------------------------------------------------- End of Addition Tests------------------------------------------

 //----------------------------------------------------- Beginning of Update Tests--------------------------------------
@test:Config {enable: true, dependsOn: [testAddNewCustomerRecord, testCustomerSearchOperation]}
function testUpdateCustomerRecord() {
    log:print("testUpdateCustomerRecord");
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
        internalId: customerId,
        entityId: "Test_Customer_test_Update",
        isPerson: true,
        salutation: "Mr",
        firstName: "TestFirstName",
        middleName: "TestMiddleName",
        lastName: "TestLastName", 
        companyName: "Wso2",
        phone: "0751234567",
        fax: "0342212345",
        email: "sandusandu@wsoi2.com",
        subsidiary: subsidiary,
        //defaultAddress: "colobmbo7,Sri Lanka",
        isInactive: false,
        //category: EMPTY_STRING,
        title: "TestTilte",
        homePhone: "0348923456",
        mobilePhone: "3243243421",
        accountNumber: "ac9092328483",
        addressbookList: [customerAddressbook]
        //currencyList: [cur] currency is not added.

    };
    RecordUpdateResponse|error output = netsuiteClient->updateCustomerRecord(customer);
    if (output is RecordUpdateResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn: [testSalesOrderAddOperation]}
function testSalesOrderUpdateOperation() {
    log:print("testSalesOrderUpdateOperation");
    RecordRef itemValue = {
        internalId : "961",
        'type: "item"
    };
    Item item = {
        item: itemValue,
        amount: 1000
    };
    SalesOrder salesOrder = {
        itemList:[item],
        internalId: salesOrderId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateSalesOrderRecord(salesOrder);
    if (output is RecordUpdateResponse) {
        log:print(output.toString());
        salesOrderId = output.internalId;
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddClassificationRecord]}
function testUpdateClassificationRecord() {
    log:print("testUpdateClassificationRecord");
    Classification classification = {
        name:"Ballerina test class_Updated",
        internalId: classificationId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateClassificationRecord(classification);
    if (output is RecordAddResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddAccountRecord]}
function testUpdateAccountRecord() {
    log:print("testUpdateAccountRecord");
    Account account = {
        acctName: "Ballerina test account_updated",
        internalId: customerAccountId
    };
    RecordUpdateResponse|error output = netsuiteClient->updateAccountRecord(account);
    if (output is RecordAddResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.message());
    }
}

@test:Config {enable: true, dependsOn: [testAddInvoiceRecord, testAddCurrencyRecord]}
function testUpdateInvoiceRecord() {
    log:print("testUpdateInvoiceRecord");
    Invoice invoice = {
        internalId: invoiceId,
        email: "test@ecosystem.com"
    };
    RecordUpdateResponse|error output = netsuiteClient->updateInvoiceRecord(invoice);
    if (output is RecordAddResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.message());
    }
}


//---------------------------------------End of Update Tests------------------------------------------------------------

//---------------------------------------Beginning of Deletion Tests----------------------------------------------------
@test:Config {enable: true, dependsOn: [testCustomerSearchOperation, testUpdateCustomerRecord, testCustomerRecordGetOperation]}
function testCustomerDeleteRecord() {
    log:print("Record Deletion Start");
    log:print("testCustomerDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : customerId,
        recordType: "customer"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}
@test:Config {enable: true, dependsOn:[testAddContactRecord]}
function testContactDeleteOperation() {
    log:print("testContactDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : contactId,
        recordType: "contact"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testAddCurrencyRecord, testCurrencyRecordGetOperation]}
function testCurrencyDeleteOperation() {
    log:print("testCurrencyDeleteRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : currencyId,
        recordType: "currency"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}   
    
@test:Config {enable: true, dependsOn:[testUpdateClassificationRecord]}
function testDeleteClassificationRecord() {
    log:print("testDeleteClassificationRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : classificationId,
        recordType: "classification"
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testAccountSearchOperation,testUpdateAccountRecord]}
function testDeleteAccountRecord() {
    log:print("testDeleteAccountRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : customerAccountId,
        recordType: ACCOUNT
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testSalesOrderUpdateOperation]}
function testDeleteSalesOrderRecord() {
    log:print("testDeleteAccountRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : salesOrderId,
        recordType: SALES_ORDER
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}

@test:Config {enable: true, dependsOn:[testAddInvoiceRecord]}
function testDeleteInvoiceRecord() {
    log:print("testDeleteAccountRecord");
    RecordDetail recordDeletionInfo = {
        recordInternalId : invoiceId,
        recordType: INVOICE
    };
    RecordDeletionResponse|error output = netsuiteClient->deleteRecord(recordDeletionInfo);
    if (output is RecordDeletionResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }
}
//-----------------------------------------------------End of Deletion Tests----------------------------------------------

//----------------------------------------------------Beginning of Search Tests-----------------------------------------
@test:Config {enable: true}
function testCustomerSearchOperation() {
    log:print("testCustomerSearchOperation");
    SearchElement searchRecord = {
        fieldName: "lastName",
        searchType: SEARCH_STRING_FIELD,
        operator: "is",
        value1: "TestSilva"
    };
    SearchElement[] searchData = [];
    searchData.push(searchRecord);
    Customer|error output = netsuiteClient->searchCustomerRecord(searchData);
    if (output is Customer) {
        log:print(output?.entityId.toString());     
    } else {
        test:assertFalse(true, output.message());
    }
}

@test:Config {enable: true, dependsOn: [testUpdateAccountRecord]}
function testAccountSearchOperation() {
    log:print("testAccountSearchOperation");
    SearchElement searchRecord = {
        fieldName: "name",
        searchType: SEARCH_STRING_FIELD,
        operator: "is",
        value1: "Ballerina test account_updated"
    };
    SearchElement[] searchElements = [searchRecord];
    Account|error output = netsuiteClient->searchAccountRecord(searchElements);
    if (output is Account) {
        log:print(output.toString());     
    } else {
        test:assertFalse(true, output.message());
    }
}
//----------------------------------------------------End of Search Tests-----------------------------------------------

//----------------------------------------------------Beginning of Miscellaneous tests----------------------------------
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

@test:Config {enable: true, dependsOn: [testAddNewCustomerRecord]} 
function testCustomerRecordGetOperation() {
    log:print("testCustomerRecordGetOperation");
    RecordDetail recordDetail = {
        recordInternalId: customerId,
        recordType: "customer"
    };
    Customer|error output = netsuiteClient->getCustomerRecord(recordDetail);
    if (output is error) {
        test:assertFalse(false, output.message());
    } else {
       log:print(output.toString()); 
    }
}

@test:Config {enable: true, dependsOn: [testAddCurrencyRecord]} 
function testCurrencyRecordGetOperation() {
    log:print("testCurrencyRecordGetOperation");
    RecordDetail recordDetail = {
        recordInternalId: currencyId,
        recordType: "currency"
    };
    Currency|error output = netsuiteClient->getCurrencyRecord(recordDetail);
    if (output is error) {
        test:assertFalse(false, output.message());
    } else {
       log:print(output.toString()); 
    }
}

@test:Config {enable: true} 
function testClassificationRecordGetOperation() {
    log:print("testClassificationRecordGetOperation");
    RecordDetail recordDetail = {
        recordInternalId: "1",
        recordType: "classification"
    };
    Classification|error output = netsuiteClient->getClassificationRecord(recordDetail);
    if (output is error) {
        test:assertFalse(false, output.message());
    } else {
       log:print(output.toString()); 
    }
}

@test:Config {enable: true} 
function testInvoiceRecordGetOperation() {
    log:print("testInvoiceRecordGetOperation");
    RecordDetail recordDetail = {
        recordInternalId: "1",
        recordType: "invoice"
    };
    Invoice|error output = netsuiteClient->getInvoiceRecord(recordDetail);
    if (output is error) {
        test:assertFalse(false, output.message());
    } else {
       log:print(output.toString()); 
    }
}

@test:Config {enable: true} 
function testSalesOrderGetOperation() {
    log:print("testSalesOrderGetOperation");
    RecordDetail recordDetail = {
        recordInternalId: "34888",
        recordType: SALES_ORDER
    };
    SalesOrder|error output = netsuiteClient->getSalesOrderRecord(recordDetail);
    if (output is error) {
        test:assertFalse(false, output.message());
    } else {
       log:print(output.toString()); 
    }
}
//add usecase type sample in doc
//restrictions