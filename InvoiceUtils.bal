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

function mapInvoiceRequestValue(Invoice invoice) returns string {
    string finalResult = "";
    map<anydata>|error invoiceMap = invoice.cloneWithType(MapAnydata);
    if (invoiceMap is map<anydata>) {
        string[] keys = invoiceMap.keys();
        int position = 0;
        foreach var item in invoice {
            if (item is string|decimal) {
                finalResult += setSimpleType(keys[position], item, "tranSales");
            } else if (item is RecordRef) {
                finalResult += setRecordRef(<RecordRef>item, "tranSales");
            }    
            position += 1;
        }
    }
    return finalResult;
}