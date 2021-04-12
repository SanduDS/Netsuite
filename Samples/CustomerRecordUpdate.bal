import ballerina/log;
import sandudslk/netsuite;

//Configurable variables
configurable string accountId = ?;
configurable string consumerId = ?;
configurable string consumerSecret = ?;
configurable string token = ?;
configurable string tokenSecret = ?;
configurable string baseURL = ?;

//Netsuite connector configuration record is created
netsuite:NetsuiteConfiguration config = {
    accountId: accountId,
    consumerId: consumerId,
    consumerSecret: consumerSecret,
    token: token,
    tokenSecret: tokenSecret,
    baseURL: baseURL
};

//Creating Ballerina Netsuite client
netsuite:Client netsuiteClient = check new (config);

public function main() {
    //Example for element that can be updated by setting the values to the records
    netsuite:RecordRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    netsuite:Address ad02 = {
        country: "_sriLanka",
        addr1: "RuwanmagaBombuwala",
        addr2:"Dodangoda",
        city:"Colombo07",
        override: true
    };

    netsuite:RecordRef currency = {
        internalId : "1",
        'type: "currency"
    };

    netsuite:CustomerAddressbook customerAddressbook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "myAddress",
        isResidential: true,
        addressBookAddress: [ad02]
    };

    netsuite:CustomerCurrency  cur = {
        currency:currency,
        balance: 1200.13,
        depositBalance: 10000,
        overdueBalance: 120,
        unbilledOrders: 1000,
        overrideCurrencyFormat: false
    };
    
    netsuite:Customer customer= {
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

    //Providing the existing record detail to be updated in Netsuite
    netsuite:RecordUpdateInfo info = {
        instance: customer,
        internalId: "<interanlId of the record>",
        recordType: CUSTOMER
    };

    netsuite:RecordUpdateResponse|error output = netsuiteClient->updateRecord(info);
    if (output is netsuite:RecordUpdateResponse) {
        log:print(output.toString());
    } else {
        log:print(output.message());
    }
}
