import ballerina/test;
import ballerina/log;

configurable string accountId = ?;
configurable string consumerId = ?;
configurable string consumerSecret = ?;
configurable string token = ?;
configurable string tokenSecret = ?;
configurable string baseURL = ?;

NetsuiteConfiguration config = {
    accountId: accountId,
    consumerId: consumerId,
    consumerSecret: consumerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL
};

Client netsuiteClient = checkpanic new (config);
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

    AddRecordResponse|error output = netsuiteClient->addNewContactRecord(contact);
    if (output is AddRecordResponse) {
        log:print("outside : "+ output.toString());
    } else {
        test:assertFail(output.toString());
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

    AddRecordResponse|error output = netsuiteClient->addNewCustomerRecord(customer);
    if (output is AddRecordResponse) {
        log:print(output.toString());
        customerId = output.internalId;
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


    AddRecordResponse|error output = netsuiteClient->addNewCurrencyRecord(currency);
    if (output is AddRecordResponse) {
        log:print(output.toString());
    } else {
        test:assertFail(output.toString());
    }

}

@test:Config {enable: true, dependsOn: [testAddCustomerRecord]}
function testDeleteRecord() {
    log:print("testCustomerDeleteRecord");
    DeleteRequest deleteRequest = {
        recordInternalId : customerId,
        recordType: "customer"
    };
    DeleteRecordResponse|error? output = netsuiteClient->deleteRecord(deleteRequest);
    if (output is DeleteRecordResponse) {
        log:print(output.toString());
    } else if (output is error){
        test:assertFail(output.toString());
    }
    log:print("testContactDeleteRecord");
    deleteRequest = {
        recordInternalId : contactId,
        recordType: "contact"
    };
    output = netsuiteClient->deleteRecord(deleteRequest);
    if (output is DeleteRecordResponse) {
        log:print(output.toString());
    } else if (output is error){
        test:assertFail(output.toString());
    }
    log:print("testCurrencyDeleteRecord");
    deleteRequest = {
        recordInternalId : currencyId,
        recordType: "currency"
    };
    output = netsuiteClient->deleteRecord(deleteRequest);
    if (output is DeleteRecordResponse) {
        log:print(output.toString());
    } else if (output is error){
        test:assertFail(output.toString());
    }


}
