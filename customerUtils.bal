// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

function MapCustomerRequestValue(Customer customer) returns string {
    string finalResult = "";
    map<anydata>|error customerMap = customer.cloneWithType(MapAnydata);
    if (customerMap is map<anydata>) {
        string[] keys = customerMap.keys();
        int position = 0;
        foreach var item in customer {
            if (item is string|boolean) {
                finalResult += setSimpleType(keys[position], item, "listRel");
            } else if (item is RecordRef) {
                finalResult += setRecordRef(<RecordRef>item, "listRel");
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
                    currencyList += setRecordRef(<RecordRef>item, "listRel");
                }
                mainPosition += 1;
            }
        }
        customerCurrencyList += string`<currency>${currencyList}</currency>`;
    }
    return customerCurrencyList;
}

