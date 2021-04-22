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

public type Item record {
    RecordRef job?;
    RecordRef subscription?;
    RecordRef item;
    decimal quantityAvailable?;
    decimal quantityOnHand?;
    decimal quantity?;
    RecordRef units?;
    string description?;
    RecordRef price?;
    string rate?;
    decimal amount;
    boolean isTaxable?;
    RecordRef location?;
};

public type SalesOrder record {
    string internalId?;
    string createdDate?;
    RecordRef customForm?;
    RecordRef entity?;
    RecordRef job?;
    RecordRef currency?;
    RecordRef drAccount?;
    RecordRef fxAccount?;
    string tranDate?;
    string tranId?;
    RecordRef entityTaxRegNum?;
    RecordRef createdFrom?;
    SalesOrderStatus|string orderStatus?;
    string nextBill?;
    RecordRef pportunity?;
    RecordRef salesRep?;
    string contribPct?;
    RecordRef partner?;
    RecordRef salesGroup?;
    RecordRef syncSalesTeams?;
    RecordRef leadSource?;
    string startDate?;
    string endDate?;
    string otherRefNum?;
    string memo?;
    string salesEffectiveDate?;
    boolean excludeCommission?;
    decimal totalCostEstimate?;
    decimal estGrossProfit?;
    decimal estGrossProfitPercent?;
    decimal exchangeRate?;
    decimal promoCode?;
    string currencyName?;
    RecordRef discountItem?;
    string discountRate?;
    boolean isTaxable?;
    RecordRef taxItem?;
    decimal taxRate?;
    boolean toBePrinted?;
    boolean toBeEmailed?;
    string email?;
    boolean toBeFaxed?;
    string fax?;
    RecordRef messageSel?;
    string message?;
    RecordRef paymentOption?;
    Address billingAddress?;
    RecordRef billAddressList?;
    Address shippingAddress?;
    boolean shipIsResidential?;
    RecordRef shipAddressList?;
    string shipDate?;
    decimal subTotal?;
    decimal discountTotal?;
    decimal taxTotal?;
    decimal total?;
    decimal balance?;
    boolean paypalProcess?;
    RecordRef billingSchedule?;
    string status?;
    RecordRef subsidiary?;
    Item[] itemList?;
};

public type Invoice record {
    decimal recognizedRevenue?;
    decimal discountTotal?;
    decimal deferredRevenue?;
    decimal total?;
    RecordRef department?;
    string createdDate?;
    RecordRef currency?;
    string email?;
    string lastModifiedDate?;
    string status?;
    RecordRef entity?;
    string invoiceId?;
    Classification classification?;
    RecordRef subsidiary?;
    string internalId?;
    Item[] itemList?;
};
