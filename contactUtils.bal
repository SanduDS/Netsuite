
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
