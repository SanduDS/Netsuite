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

public type Contact record {
    RecordRef customForm?;
    string entityId?;
    RecordRef contactSource?;
    RecordRef company?;
    string salutation?;
    string firstName?;
    string middleName?;
    string lastName?;
    string title?;
    string phone?;
    string fax?;
    string email?;
    string defaultAddress?;
    boolean isPrivate?;
    boolean isInactive?;
    RecordRef subsidiary?;
    string phoneticName?;
    Category[] categoryList?;
    string altEmail?;
    string officePhone?;
    string homePhone?;
    string mobilePhone?;
    RecordRef supervisor?;
    string supervisorPhone?;
    RecordRef assistant?;
    string assistantPhone?;
    string comments?;
    GlobalSubscriptionStatusType globalSubscriptionStatus?;
    string image?;
    boolean billPay?;
    string dateCreated?;
    string lastModifiedDate?;
    ContactAddressBook[] addressBookList?;
    Subscription[] SubscriptionsList?;
};

public type Customer record {
    string entityId;
    boolean isPerson?;
    string salutation?;
    string firstName?;
    string middleName?;
    string lastName?;
    string companyName?;
    string phone?;
    string fax?;
    string email?;
    string defaultAddress?;
    boolean isInactive?;
    RecordRef category?;
    RecordRef subsidiary?;
    string title?;
    string homePhone?;
    string mobilePhone?;
    string accountNumber?;
    CustomerAddressbook[] addressbookList?;
    CustomerCurrency[] currencyList?;
};

public type Subsidiary record {
    string name?;
    //Currency currency?;
    string country?;
    string email?;
    boolean isElimination?;
    boolean isInactive?;
    string legalName?;
    string url?;
};

# Description
#
# + displaySymbol - Parameter Description  
# + currencyPrecision - Parameter Description  
# + symbol - Parameter Description  
# + exchangeRate - Parameter Description  
# + isInactive - Parameter Description  
# + isBaseCurrency - Parameter Description  
# + name - Parameter Description  
public type Currency record {
    string name?;
    string symbol?;
    decimal exchangeRate?;
    string displaySymbol?;
    string currencyPrecision?;
    boolean isInactive?;
    boolean isBaseCurrency;
};