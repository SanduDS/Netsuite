function mapSalesOrderRequestValue(SalesOrder salesOrder) returns string {
    string finalResult = "";
    map<anydata>|error salesOrderMap = salesOrder.cloneWithType(MapAnydata);
    if (salesOrderMap is map<anydata>) {
        string[] keys = salesOrderMap.keys();
        int position = 0;
        foreach var item in salesOrder {
            if (item is string|boolean|decimal|int|SalesOrderOrderStatus) {
                finalResult += setSimpleType(keys[position], item, "tranSales");
            } else if (item is RecordRef) {
                finalResult += setRecordRef(<RecordRef>item, "tranSales");
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
                                itemValue += setRecordRef(<RecordRef>element, "tranSales");
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
    return finalResult;
}
