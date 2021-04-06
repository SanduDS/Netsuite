
public type TokenData record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string nounce;
    string timestamp;
};

public type AddRecordResponse record {
    boolean isSuccess;
    string internalId;
    string recordType;
};

public type DeleteRecordResponse record {
    *AddRecordResponse;
};

public type UpdateRecordResponse record {
    *AddRecordResponse;
};

public type DeleteRequest record {
    string recordInternalId;
    string recordType;
    string deletionReasonId?;
    string deletionReasonMemo?;
};

public type UpdateRequest record {
    AddRecordType instance;
    string internalId;
};

type MapAnydata map<anydata>;