import ballerina/jsonutils;
import ballerina/http;

public enum ConsolidatedRate {
    AVERAGE_CONSILIDATED_RATE = "_average",
    CURRENCY_CONSILIDATED_RATE = "_current",
    HISTORICAL_CONSILIDATED_RATE = "_historical"
}

function mapAccountRecordFields(Account account) returns string {
    string finalResult = "";
    map<anydata>|error accountMap = account.cloneWithType(MapAnydata);
    if (accountMap is map<anydata>) {
        string[] keys = accountMap.keys();
        int position = 0;
        foreach var item in accountMap {
            if (item is string|boolean|decimal) {
                finalResult += setSimpleType(keys[position], item, "listAcct");
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            }
            position += 1;
        }
    }
    return finalResult;
}

function wrapAccountElementsToBeCreatedWithParentElement(string subElements) returns string {
    return string `<urn:record xsi:type="listAcct:Account" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

function wrapAccountElementsToUpdatedWithParentElement(string subElements, string internalId) returns string {
    return string `<urn:record xsi:type="listAcct:Account" internalId="${internalId}" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

//-------------------------------------search functions-----------------------------------------------------------------

function getAccountSearchRequestBody(SearchElement[] searchElements) returns string {
    return string `<soapenv:Body> <urn:search xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
    <urn:searchRecord xsi:type="listAcct:AccountSearch" 
    xmlns:listAcct="urn:accounting_2020_2.lists.webservices.netsuite.com">
    <basic xsi:type="ns1:AccountSearchBasic" 
    xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">${getSearchElement(searchElements)}</basic>
    </urn:searchRecord></urn:search></soapenv:Body></soapenv:Envelope>`;
}

function buildAccountSearchPayload(NetSuiteConfiguration config,SearchElement[] searchElement) returns xml|error {
    string requestHeader = check buildXMLPayloadHeader(config);
    string requestBody = getAccountSearchRequestBody(searchElement);
    return check getFinalPayload(requestHeader, requestBody);   
}

function getAccountSearchResult(http:Response response) returns Account|error {
    xml xmlValue = check getXMLRecordListFromSearchResult(response);
    xmlValue = check replaceRegexInXML(xmlValue, "listAcct:");
    string|error instanceType =  xmlValue.xsi_type;
    // xml:Text x = <xml:Text>xmlValue/<entityId>;
    // string test=  xmlLib:getContent(x).toString();
    string internalId = checkStringValidity(xmlValue.internalId).toString();
    Account account = {
        internalId: internalId
    };
    json validatedJson = getValidJson(jsonutils:fromXML(xmlValue));
    check mapAccountFields(validatedJson, account);
    return account;
}
function mapAccountFields(json accountTypeJson, Account account) returns error? {
    json valueList = getValidJson(accountTypeJson.'record.'record);
    account.acctName = getValidJson(valueList.acctName).toString();
    account.acctNumber = getValidJson(valueList.acctNumber).toString(); 
    account.legalName = getValidJson(valueList.legalName).toString();
    account.acctType = getValidJson(valueList.acctType).toString();
    account.generalRate = getValidJson(valueList.generalRate).toString();
    account.cashFlowRate = getValidJson(valueList.cashFlowRate).toString();   
}

