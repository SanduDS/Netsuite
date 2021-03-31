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

@test:Config {enable: true}
function testGetAll() {
    log:print("testAddRecord");
    //AddContact
    RecordRef cusForm = {
        internalId : "-40",
        'type: "customForm"
    };

    Contact contact= {
        customForm :cusForm,
        firstName: "testDanu",
        middleName: "sandu",
        isPrivate: false
    };
    
    json|error? output = netsuiteClient->addNewRecordInstance(contact);
}
