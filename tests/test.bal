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
    RecordRef cusForm = {
        internalId : "-40",
        'type: "customForm"
    };

    RecordRef subsidiary = {
        internalId : "11",
        'type: "subsidiary"
    };

    Contact contact= {
        customForm :cusForm,
        firstName: "testDanu",
        middleName: "sandu",
        isPrivate: false,
        subsidiary: subsidiary
    };
    
    xml|error? output = netsuiteClient->addNewRecordInstance(contact);
    if (output is xml) {
        log:print(output.toString());
    } else if (output is error) {
        log:print(output.toString());
    }

}
