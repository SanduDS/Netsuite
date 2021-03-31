import ballerina/time;
import ballerina/lang.'string as stringLib;
import ballerina/lang.'xml as xmlLib;
import ballerina/log;


function buildAddRecordPayload(AddRecordType recordRequest, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string? elements = addRecordFields(recordRequest);
    string body = string `<soapenv:Body>
    <urn:get>
    ${elements.toString()}
    </urn:get>
    </soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    return xmlPayload; 
}

isolated function buildHeader(NetsuiteConfiguration config) returns string|error{
    time:Time timeNow = time:currentTime();
    string timeToSend = stringLib:substring(timeNow.time.toString(), 0, 10);
    string uuid = getRandomString();
    string signature = check getNetsuiteSignature(timeToSend, uuid, config);
    string payload = string `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:urn="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:urn1="urn:core_2020_2.platform.webservices.netsuite.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
    <urn:tokenPassport><urn1:account>${config.accountId}</urn1:account>
    <urn1:consumerKey>${config.consumerId}</urn1:consumerKey>
    <urn1:token>${config.token}</urn1:token>
    <urn1:nonce>${uuid}</urn1:nonce>
    <urn1:timestamp>${timeToSend}</urn1:timestamp>
    <urn1:signature algorithm="HMAC-SHA256">${signature}</urn1:signature>
    </urn:tokenPassport>
    </soapenv:Header>`;
    return payload;
}

type MapAnydata map<anydata>;

function addRecordFields(AddRecordType recordRequest) returns string? {
    if (recordRequest is Customer) {
          
    } else {
          map<anydata>|error contact = recordRequest.cloneWithType(MapAnydata);
        if (contact is map<anydata>) {
            log:print(contact.toString());
        }
    }
        
}
//Setting record types--------------------------------------------------------------------------------------------------
function setRecordRef(RecordRef recordRef) returns string {
    string? externalId =  recordRef?.externalId;
    string recordType = recordRef.'type;
    string xmlRecord = string `<listRel:${recordType}> 
    <urn1:internalId>${recordRef.internalId}</urn1:internalId>
    <urn1:type>${recordType}</urn1:type>
    </listRel:${recordType}>`;
    if(externalId is string) {
        xmlRecord = string `<listRel:${recordType}> 
        <urn1:internalId>${recordRef.internalId}</urn1:internalId>
        <urn1:externalId>${externalId}</urn1:externalId>
        <urn1:type>${recordType}</urn1:type>
        </listRel:${recordType}>`;
    }
    return  xmlRecord;
}

function setSimpleType(string elementName, string|boolean value, string XSDName) returns string {
    if(value is string) {
        return string `<${XSDName}:${elementName}>${value}</${XSDName}:${elementName}>`;
    }else {
        return string `<${XSDName}:${elementName}>${value.toString()}</${XSDName}:${elementName}>`;
    }
}
