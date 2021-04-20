import ballerina/crypto;
import ballerina/lang.'array;
// import ballerina/lang.'xml as xmlLib;
// import ballerina/lang.'string as stringLib;
// import ballerina/time;
import ballerina/uuid;
import ballerina/regex;
// import ballerina/lang.value as value;
// import ballerina/lang.'map as mapLib;

isolated function getNetsuiteSignature(string timeNow, string UUID, NetSuiteConfiguration config) returns string|error {
    TokenData tokenData = {
        accountId: config.accountId,
        consumerId: config.consumerId,
        consumerSecret: config.consumerSecret,
        tokenSecret: config.tokenSecret,
        token: config.token,
        nounce: UUID,
        timestamp: timeNow
    };
    string token = check generateSignature(tokenData);
    return token;
}

isolated function getRandomString() returns string {
    string uuid1String = uuid:createType1AsString();
    return regex:replaceAll(uuid1String, "-", "s");
}

isolated function makeBaseString(TokenData values) returns string {
    string token = values.accountId + "&" + values.consumerId + "&" + values.token + "&" + values.nounce + "&" + values.
    timestamp;
    return token;
}

isolated function createKey(TokenData values) returns string {
    string keyValue = values.consumerSecret + "&" + values.tokenSecret;
    return keyValue;
}

isolated function generateSignature(TokenData values) returns string|error {
    string baseString = makeBaseString(values);
    string keyValue = createKey(values);
    byte[] data = baseString.toBytes();
    byte[] key = keyValue.toBytes();
    byte[] hmac = check crypto:hmacSha256(data, key);
    return 'array:toBase64(hmac);
}