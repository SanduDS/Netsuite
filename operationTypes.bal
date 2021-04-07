public type AddRecordType Customer|Contact|Currency|Subsidiary;

public type AddRequest record {
    AddRecordType instance;
    string recordType;
};

