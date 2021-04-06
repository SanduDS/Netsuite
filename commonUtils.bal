import ballerina/time;
import ballerina/lang.'string as stringLib;
import ballerina/lang.'xml as xmlLib;
import ballerina/log;

isolated function buildHeader(NetsuiteConfiguration config) returns string|error {
    time:Time timeNow = time:currentTime();
    string timeToSend = stringLib:substring(timeNow.time.toString(), 0, 10);
    string uuid = getRandomString();
    string signature = check getNetsuiteSignature(timeToSend, uuid, config);
    string header = string `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:urn="urn:messages_2020_2.platform.webservices.netsuite.com" 
    xmlns:urn1="urn:core_2020_2.platform.webservices.netsuite.com"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soapenv:Header>
    <urn:tokenPassport><urn1:account>${
    config.accountId}</urn1:account>
    <urn1:consumerKey>${config.consumerId}</urn1:consumerKey>
    <urn1:token>${
    config.token}</urn1:token>
    <urn1:nonce>${uuid}</urn1:nonce>
    <urn1:timestamp>${timeToSend}</urn1:timestamp>
    <urn1:signature algorithm="HMAC-SHA256">${
    signature}</urn1:signature>
    </urn:tokenPassport>
    </soapenv:Header>`;
    return header;
}

function setRecordRef(RecordRef recordRef, string? XSDName = ()) returns string {
    string? externalId = recordRef?.externalId;
    string recordType = recordRef.'type;
    string xmlRecord = string `<${recordType} xsi:type="urn1:RecordRef" internalId="${recordRef.internalId}"/>`;
    if (externalId is string) {
        xmlRecord = string `<${recordType} xsi:type="urn1:RecordRef" internalId="${recordRef.internalId}" 
        externalId="${externalId}"/>`;
    } 
    return xmlRecord;
}

function setSimpleType(string elementName, string|boolean|decimal|int value, string XSDName) returns string {
    if (value is string) {
        return string `<${XSDName}:${elementName}>${value}</${XSDName}:${elementName}>`;
    } else {
        return string `<${XSDName}:${elementName}>${value.toString()}</${XSDName}:${elementName}>`;
    }
}

function buildAddRecordPayload(AddRecordType recordRequest, NetsuiteConfiguration config, string recordType) returns xml|error {
    string header = check buildHeader(config);
    string elements = setRecordAddingOperationFields(recordRequest, recordType);
    string body = string `<soapenv:Body>
    <urn:add>
            ${elements.toString()}
    </urn:add>
    </soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    //log:print(xmlPayload.toString());
    return xmlPayload;
}

function buildDeleteRecordPayload(DeleteRequest deleteRequest, NetsuiteConfiguration config) returns xml|error {
    string header = check buildHeader(config);
    string elements = setDeletePayload(deleteRequest);
    string body = string `<soapenv:Body>
    <urn:delete>
            ${elements.toString()}
    </urn:delete>
    </soapenv:Body>
    </soapenv:Envelope>`;
    string payload = header + body;
    xml xmlPayload = check xmlLib:fromString(payload);
    log:print(xmlPayload.toString());
    return xmlPayload;
}

function setRecordAddingOperationFields(AddRecordType request ,string recordType) returns string {
    if (recordType == "Customer") {
        string rquestXml = MapCustomerRequestValue(<Customer>request);
        return string `<urn:record xsi:type="listRel:Customer" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`; 
    }else if (recordType == "Contact") {
        string rquestXml = MapContactRequestValue(<Contact>request);
        return string `<urn:record xsi:type="listRel:Contact" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    } else if (recordType == "Currency") {
        string rquestXml = MapCurrencyRequestValue(<Currency>request);
        return string `<urn:record xsi:type="listAcct:Currency" 
        xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    } else if (recordType == "SalesOrder") {
        string rquestXml = mapSalesOrderRequestValue(<SalesOrder>request);
        return string `<urn:record xsi:type="tranSales:SalesOrder" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${rquestXml.toString()}
         </urn:record>`;
    }
    return "";
}

function setDeletePayload(DeleteRequest deleteRequest) returns string{
    if(deleteRequest?.deletionReasonId is () || deleteRequest?.deletionReasonMemo is ()) {
        return string `<urn:baseRef type="${deleteRequest.recordType}" internalId="${deleteRequest.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>`;
    } else {
        return string `<urn:baseRef type="${deleteRequest.recordType}" internalId="${deleteRequest.recordInternalId}" 
        xsi:type="urn1:RecordRef"/>
        <urn1:deletionReason>
        <deletionReasonCode internalId="${deleteRequest?.deletionReasonId.toString()}"/>
        <deletionReasonMemo>${deleteRequest?.deletionReasonMemo.toString()}</deletionReasonMemo>
        </urn1:deletionReason>`;   
    }  
}
//<urn:baseRef internalId="${item.internalId.toString()}" type="${item.recordType.toString()}" xsi:type="urn1:RecordRef"/>