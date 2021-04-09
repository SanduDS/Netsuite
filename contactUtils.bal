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

function MapContactRequestValue(Contact contact) returns string {
    string finalResult = "";
    map<anydata>|error contactMap = contact.cloneWithType(MapAnydata);
    if (contactMap is map<anydata>) {
        string[] keys = contactMap.keys();
        int position = 0;
        foreach var item in contact {
            if (item is string|boolean) {
                finalResult += setSimpleType(keys[position], item, "listRel");
            } else if (item is RecordRef) {
                finalResult += setRecordRef(<RecordRef>item, "listRel");
            } else if (item is Category[]) {
                string categoryList = "";
                foreach RecordRef category in item {
                    categoryList += setRecordRef(category, "listRel");
                }
                finalResult += string `<listRel:categoryList>${categoryList}</listRel:categoryList>`;
            } else if (item is GlobalSubscriptionStatusType) {
                finalResult += string `<listRel:globalSubscriptionStatus>${item.toString()}
                </listRel:globalSubscriptionStatus>`;
            } else if (item is ContactAddressBook[]) {
                string addressList = prepareAddressList(item);
                finalResult += string`<listRel:addressbookList>${addressList}</listRel:addressbookList>`;
            } 
            position += 1;
        }
    }
    return finalResult;
}

function prepareAddressList(ContactAddressBook[] addressBooks) returns string {
    string contactAddressBook= "";
    foreach ContactAddressBook addressBookItem in addressBooks {
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
        contactAddressBook += string`<addressbook>${addressList}</addressbook>`;
    }
    return contactAddressBook;
}