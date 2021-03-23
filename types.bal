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

public type TokenData record {
    string accountId;
    string consumerId;
    string consmerSecret;
    string tokenSecret;
    string token;
    string nounce;
    string timestamp;
};

public type SavedSearchResult record {
    int numberOfRecords?;
    boolean isSuccess;
    RecordRef[] recordRefList = [];
};

public type RecordRef record {
    string name;
    string scriptId;
    string internalId;
};

public type SearchField record {
    CustomerSearchElement|TransactionSearchElement elementName?;
    BasicSearchStringFieldOperation|SearchDoubleFieldOperator|BasicSearchEnumORMultiSelectFieldOperator|SearchDateFieldOperator operator;
    string internalId?;
    string externalId?;
    string value?;
    DateField dateField?;
    DoubleField doubleField?;
};

public type DoubleField record {
    SearchDoubleFieldOperator operator;
    string searchValue;
    string searchValue2;
};

public type DateField record {
    SearchDateFieldOperator operator;
    string preDefinedDate?;
    string date?;
    string date2?;
};

public type CustomerSearchParameters record {|
    SearchField[] SearchField = [];
|};

public type GetListRequestField record {|
    string internalId;
    string recordType;
|};

public type GetListResponse record {
    json[] list;
    boolean isSuccess;
};

public type GetResponse record {
    json list?;
    boolean isSuccess?;
    Invoice invoice?;

};

public type GetRequestField record {|
    string internalId;
    string recordType;
|};

public type TrasactionSearchResponse record {
    Invoice[] invoices?;
    json[] payload?;
    boolean isSuccess;
};
