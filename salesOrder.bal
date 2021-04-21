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

function mapSalesOrderRecordFields(SalesOrder salesOrder) returns string {
    string finalResult = EMPTY_STRING;
    map<anydata>|error salesOrderMap = salesOrder.cloneWithType(MapAnyData);
    if (salesOrderMap is map<anydata>) {
        string[] keys = salesOrderMap.keys();
        int position = 0;
        foreach var item in salesOrder {
            if (item is string|boolean|decimal|int|SalesOrderOrderStatus) {
                finalResult += setSimpleType(keys[position], item, TRAN_SALES);
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item);
            } else if (item is Address) {
                string addressBook = prepareSalesOrderXMLAddressElement(item);
                finalResult += string `<billingAddress>${addressBook}</billingAddress>`;        
            } else if (item is Item[]) {
                string itemList = prepareSalesOrderItemListElement(item);
                finalResult +=string `<itemList>${itemList}</itemList>`;
            }       
            position += 1;
        }
    }
    return finalResult;
}

function prepareSalesOrderXMLAddressElement(Address address) returns string {
    map<anydata>|error AddressMap = address.cloneWithType(MapAnyData);
    int index = 0;
    string addressBook = EMPTY_STRING;
    foreach var element in address {
        if (AddressMap is map<anydata>) {
            string[] addressKeys = AddressMap.keys();
            addressBook += string `<${addressKeys[index]}>${element.toString()}</${addressKeys[index]}>`;
        }
        index += 1;  
    }
    return addressBook;
}

function prepareSalesOrderItemListElement(Item[] items) returns string{
    string itemList = EMPTY_STRING;
    foreach Item nsItem in items {
        map<anydata>|error itemMap = nsItem.cloneWithType(MapAnyData);
        int itemPosition = 0;
        string itemValue =EMPTY_STRING;
        foreach var element in nsItem {
            if (itemMap is map<anydata>) {
                  string[] itemKeys = itemMap.keys();
                if(element is string|int|boolean|decimal) {
                    itemValue += string `<${itemKeys[itemPosition]}>${element.toString()}</${itemKeys[itemPosition]}>`;
                } else if (element is RecordRef){
                    itemValue += getXMLRecordRef(<RecordRef>element);
                }
            }
            itemPosition += 1;  
        }
        itemList += string `<item>${itemValue}</item>`;
    }
    return itemList;
}

function wrapSalesOrderElementsToBeCreatedWithParentElement(string subElements) returns string{
    return string `<urn:record xsi:type="tranSales:SalesOrder" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}

function wrapSalesOrderElementsToBeUpdatedWithParentElement(string subElements, string internalId) returns string{
    return string `<urn:record xsi:type="tranSales:SalesOrder" internalId="${internalId}"
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${subElements}
         </urn:record>`;
}
