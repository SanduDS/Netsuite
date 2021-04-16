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
    string finalResult = "";
    map<anydata>|error salesOrderMap = salesOrder.cloneWithType(MapAnydata);
    if (salesOrderMap is map<anydata>) {
        string[] keys = salesOrderMap.keys();
        int position = 0;
        foreach var item in salesOrder {
            if (item is string|boolean|decimal|int|SalesOrderOrderStatus) {
                finalResult += setSimpleType(keys[position], item, "tranSales");
            } else if (item is RecordRef) {
                finalResult += getXMLRecordRef(<RecordRef>item, "tranSales");
            } else if (item is Address) {
                string addressLines = "";
                map<anydata>|error AddressMap = item.cloneWithType(MapAnydata);
                int index = 0;
                string addressBook ="";
                foreach var element in item {
                    if (AddressMap is map<anydata>) {
                        string[] addressKeys = AddressMap.keys();
                        addressBook += string `<${addressKeys[index]}>${element.toString()}</${addressKeys[position]}>`;
                    }
                    index += 1;  
                }
                addressLines += string `<billingAddress>${addressBook}</billingAddress>`;        
            } else if (item is Item[]) {
                string itemList = "";
                foreach Item nsItem in item {
                    map<anydata>|error itemMap = nsItem.cloneWithType(MapAnydata);
                    int itemPosition = 0;
                    string itemValue ="";
                    foreach var element in nsItem {
                        if (itemMap is map<anydata>) {
                              string[] itemKeys = itemMap.keys();
                            if(element is string|int|boolean|decimal) {
                                itemValue += string `<${itemKeys[itemPosition]}>${element.toString()}</${itemKeys[itemPosition]}>`;
                            } else if (element is RecordRef){
                                itemValue += getXMLRecordRef(<RecordRef>element, "tranSales");
                            }
                        }
                        itemPosition += 1;  
                    }
                    itemList += string `<item>${itemValue}</item>`;  
                }
                finalResult +=string `<itemList>${itemList}</itemList>`;
            }       
            position += 1;
        }
    }
    return string `<urn:record xsi:type="tranSales:SalesOrder" 
        xmlns:tranSales="urn:sales_2020_2.transactions.webservices.netsuite.com">
            ${finalResult.toString()}
         </urn:record>`;
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
