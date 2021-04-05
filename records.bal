
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

type MapAnydata map<anydata>;