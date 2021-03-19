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

public type Customer record {
    string customForm?;
    string entityId?;
    string altName?;
    boolean isPerson?;
    string phoneticName?;
    string salutation?;
    string firstName?;
    string middleName?;
    string lastName?;
    string companyName?;
    string phone?;
    string fax?;
    string email?;
    string url?;
    string defaultAddress?;
    boolean isInactive?;
    string title?;
    string printOnCheckAs?;
    string altPhone?;
    string homePhone?;
    string mobilePhone?;
    string altEmail?;
    string comments?;
    string dateCreated?;
    string emailPreference?;
    string contribPct?;
    string vatRegNumber?;
    string accountNumber?;
    boolean taxExempt?;
    decimal creditLimit?;
    decimal balance?;
    decimal overdueBalance?;
    int daysOverdue?;
    decimal unbilledOrders?;
    decimal consolUnbilledOrders?;
    decimal consolOverdueBalance?;
    decimal consolDepositBalance?;
    decimal consolBalance?;
    int consolDaysOverdue?;
    string priceLevel?;
    string currency?;
    decimal depositBalance?;
    boolean shipComplete?;
    boolean taxable?;
    string resaleNumber?;
    string internalId?;
    string externalId?;
};

public type currency record {
    string name;
    string symbol;
    boolean isBaseCurrency;
    boolean isInactive;
    string overrideCurrencyFormat;
    string displaySymbol;
    string symbolPlacement;
    string locale;
    string formatSample;
    decimal exchangeRate;
    string fxRateUpdateTimezone;
    string currencyPrecision;
};

public type Invoice record {
    decimal amountPaid?;
    decimal amountRemaining?;
    decimal balance?;
    decimal total?;
    string createdDate?;
    string currencyName?;
    string dueDate?;
    string email?;
    string lastModifiedDate?;
    string status?;
    string transactionId?;
    string entity?;
    string entityInternalId?;
    string invoiceId?;

};
