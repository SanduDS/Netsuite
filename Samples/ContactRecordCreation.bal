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
    
    netsuite:RecordRef cusForm = {
        internalId : "<internalId>",
        'type: "customForm"
    };

    netsuite:RecordRef subsidiary = {
        internalId : "<internalId>",
        'type: "subsidiary"
    };

    netsuite:RecordRef category = {
        internalId : "<internalId>",
        'type: "category"
    };

    netsuite:Address address_01 = {
        country: "<country_name_from netsuite>",
        addr1: "<address_to_netsuite>",
        addr2:"<country_name_from netsuite>",
        city:"<country_name_from netsuite>",
        override: true
    };

    netsuite:Address address_02 = {
        country: "<country_name_from netsuite>",
        addr1: "<address_to_netsuite>",
        addr2:"<country_name_from netsuite>",
        city:"<country_name_from netsuite>",
        override: true
    };

    netsuite:ContactAddressBook contactAddressBook = {
        defaultShipping: true,
        defaultBilling: true,
        label: "<label of the contectBook>",
        addressBookAddress: [address_01]
    };
    
    netsuite:ContactAddressBook contactAddressBook02 = {
        defaultShipping: true,
        defaultBilling: true,
        label: "<label of the contectBook>",
        addressBookAddress: [address_02]
    };

    netsuite:Contact contact= {
        customForm :"<Custom Form record>",
        firstName: "<First Name>",
        middleName: "<Middle Name>",
        isPrivate: false,
        subsidiary: "<subsidiary record>",
        //categoryList:[category],
        globalSubscriptionStatus: "<subcrition type>",
        addressBookList : [contactAddressBook, contactAddressBook02]

    };

    netsuite:RecordCreationInfo info = {
        instance: <record to be added in Netsuite>,
        recordType: netsuite:CONTACT
    };

    netsuite:RecordCreationResponse|error output = netsuiteClient->addNewRecord(info);
    if (output is netsuite:RecordCreationResponse) {
        log:print(output.toString());
    } else {
        log:print(output.message());
    }
}
