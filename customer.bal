import ballerina/jsonutils;
import ballerina/http;

//------------------------------------------------Create/Update Records-------------------------------------------------
function mapCustomerRecordFields(Customer customer) returns string {
    string finalResult = "";
    map<anydata>|error customerMap = customer.cloneWithType(MapAnydata);
    if (customerMap is map<anydata>) {
        string[] keys = customerMap.keys();
        int position = 0;
        foreach var item in customer {
            if (item is string|boolean) {
                finalResult += setSimpleType(keys[position], item, "listRel");
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is CustomerAddressbook[]) {
                string addressList = prepareAddressList(item);
                finalResult += string`<listRel:addressbookList>${addressList}</listRel:addressbookList>`;
            } else if (item is CustomerCurrency[]) {
                string currencyList = prepareCurrencyList(item);
                finalResult += string`<listRel:currencyList>${currencyList}</listRel:currencyList>`;
            }
            position += 1;
        }
    }
    return finalResult;
}

function wrapCustomerElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="listRel:Customer" xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${subElements}
        </urn:record>`;
}

function wrapCustomerElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string {
    return string `<urn:record xsi:type="listRel:Customer" internalId="${internalId}" 
        xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

function prepareCustomerAddressList(CustomerAddressbook[] addressBooks) returns string {
    string customerAddressBook= "";
    foreach CustomerAddressbook addressBookItem in addressBooks {
        map<anydata>|error AddressItemMap = addressBookItem.cloneWithType(MapAnydata);
        int mainPosition = 0;
        string addressList = "";
        if(AddressItemMap is map<anydata>) {
            string[] AddressItemKeys = AddressItemMap.keys();
            foreach var item in addressBookItem {
                if(item is string|boolean) {
                    addressList += string `<${AddressItemKeys[mainPosition]}>${item.toString()}
                    </${AddressItemKeys[mainPosition]}>`;
                } else if(item is Address[]) {
                    foreach Address addressItem in item {
                        map<anydata>|error AddressMap = addressItem.cloneWithType(MapAnydata);
                        int position = 0;
                        string addressBook ="";
                        foreach var element in addressItem {
                            if (AddressMap is map<anydata>) {
                                string[] keys = AddressMap.keys();
                                addressBook += string `<${keys[position]}>${element.toString()}</${keys[position]}>`;
                            }
                            position += 1;  
                        }
                        addressList += string `<addressbookAddress>${addressBook}</addressbookAddress>`;  
                    }
                }
                mainPosition += 1;
            }
        }
        customerAddressBook += string`<addressbook>${addressList}</addressbook>`;
    }
    return customerAddressBook;
}

function prepareCurrencyList(CustomerCurrency[] currencyLists) returns string {
    string customerCurrencyList= "";
    foreach CustomerCurrency customerCurrencyItem in currencyLists {
        map<anydata>|error currencyItemMap = customerCurrencyItem.cloneWithType(MapAnydata);
        int mainPosition = 0;
        string currencyList = "";
        if(currencyItemMap is map<anydata>) {
            string[] currencyItemKeys = currencyItemMap.keys();
            foreach var item in customerCurrencyItem {
                if(item is string|boolean|decimal) {
                    currencyList += string `<${currencyItemKeys[mainPosition]}>${item.toString()}
                    </${currencyItemKeys[mainPosition]}>`;
                } else if (item is RecordRef) {
                    currencyList += getXMLRecordRef(<RecordRef>item);
                }
                mainPosition += 1;
            }
        }
        customerCurrencyList += string`<currency>${currencyList}</currency>`;
    }
    return customerCurrencyList;
}

//-------------------------------------------------Search Records-------------------------------------------------------
function getCustomerSearchRequestBody(SearchElement[] searchElements) returns string {
    return string `<soapenv:Body> <urn:search xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
    <urn:searchRecord xsi:type="listRel:CustomerSearch" 
    xmlns:listRel="urn:relationships_2020_2.lists.webservices.netsuite.com">
    <basic xsi:type="ns1:CustomerSearchBasic" 
    xmlns:ns1="urn:common_2020_2.platform.webservices.netsuite.com">${getSearchElement(searchElements)}</basic>
    </urn:searchRecord></urn:search></soapenv:Body></soapenv:Envelope>`;
}

function buildCustomerSearchPayload(NetSuiteConfiguration config,SearchElement[] searchElement) returns xml|error {
    string requestHeader = check buildXMLPayloadHeader(config);
    string requestBody = getCustomerSearchRequestBody(searchElement);
    return check getFinalPayload(requestHeader, requestBody); 
}

function getCustomerSearchResult(http:Response response) returns Customer|error {
    xml xmlValue = check getXMLRecordListFromSearchResult(response);
    xmlValue = check replaceRegexInXML(xmlValue, "listRel:");
    string|error instanceType =  xmlValue.xsi_type;
    // xml:Text x = <xml:Text>xmlValue/<entityId>;
    // string test=  xmlLib:getContent(x).toString();
    string internalId = checkStringValidity(xmlValue.internalId).toString();
    Customer customer = {
        internalId: internalId
    };
    json validatedJson = getValidJson(jsonutils:fromXML(xmlValue));
    check mapCustomerFields(validatedJson, customer);
    return customer;
}


function mapCustomerFields(json customerTypeJson, Customer customer) returns error? {
    json[] valueList = <json[]>getValidJson(customerTypeJson.'record.'record);
    foreach json element in valueList {
        boolean? extractedValue = extractBooleanValueFromJson(element.isPerson);
        if(extractedValue is boolean) {
            customer.isPerson = extractedValue;
        } 
        extractedValue = extractBooleanValueFromJson(element.isInactive); 
        if(extractedValue is boolean) {
            customer.isInactive = extractedValue;
        }
        if(element.entityId is json) {
            customer.entityId = getValidJson(element.entityId).toString();
        }
        if(element.companyName is json){
            customer.companyName = getValidJson(element.companyName).toString(); 
        }  
        if(element.salutation is json) {
            customer.salutation = getValidJson(element.salutation).toString();
        }
        if(element.firstName is json){
            customer.firstName = getValidJson(element.firstName).toString();
        }
        if(element.middleName is json){
            customer.middleName = getValidJson(element.middleName).toString();
        }       
        if(element.lastName is json) {
            customer.lastName = getValidJson(element.lastName).toString();
        }
        if(element.companyName is json) {
            customer.companyName = getValidJson(element.companyName).toString();
        }
        if(element.phone is json) {
            customer.phone = getValidJson(element.phone).toString();
        }
        if(element.fax is json) {
            customer.fax = getValidJson(element.fax).toString();
        }
        if(element.email is json) {
            customer.email = getValidJson(element.email).toString();
        }
        if(element.defaultAddress is json) {
            customer.defaultAddress = getValidJson(element.defaultAddress).toString();
        }
        if(element.category is json) {
            customer.category = getRecordRef(getValidJson(element),getValidJson(element.category));
        }
        if(element.subsidiary is json) {
            customer.subsidiary = getRecordRef(getValidJson(element), getValidJson(element.subsidiary));
        }
        if(element.title is json) {
            customer.title = getValidJson(element.title).toString();
        }
        if(element.homePhone is json) {
            customer.homePhone = getValidJson(element.homePhone).toString();
        }
        if(element.mobilePhone is json) {
            customer.mobilePhone = getValidJson(element.mobilePhone).toString();
        }
        if(element.accountNumber is json) {
            customer.accountNumber = getValidJson(element.accountNumber).toString();
        }
    }
}
