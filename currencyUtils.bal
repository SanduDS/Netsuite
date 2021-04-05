//import ballerina/log;

function MapCurrencyRequestValue(Currency currency) returns string {
    string finalResult = "";
    map<anydata>|error currencyMap = currency.cloneWithType(MapAnydata);
    if (currencyMap is map<anydata>) {
        string[] keys = currencyMap.keys();
        int position = 0;
        foreach var item in currency {
            if (item is string|boolean|decimal|int) {
                finalResult += setSimpleType(keys[position], item, "listAcct");
            } 
            position += 1;
        }
    }
    return finalResult;
}
