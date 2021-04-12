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
    netsuite:SearchField searchRecord = {
        elementName: "companyName",
        operator: "is",
        value: "80 Acres"
    };

    netsuite:SearchField[] searchData = [];
    searchData.push(searchRecord);
    netsuite:RecordSearchInfo info = {
        searchDetail: searchData,
        recordType: netsuite:CUSTOMER_TYPE
    };

    json|error output = netsuiteClient->searchRecord(info);
    if (output is json) {
        log:print(output.toString());
    } else {
        log:printError(output.message());
    }
}