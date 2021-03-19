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

public type GetListReqestFeild record {|
    string internalId;
    string recordType;
|};

public type GetListResponse record {
    json[] list;
    boolean isSuccess;
};

public type GetResponse record {
    json list;
    boolean isSuccess;
};

public type GetReqestFeild record {|
    string internalId;
    string recordType;
|};