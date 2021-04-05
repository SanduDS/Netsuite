public type AddRecordType Customer|Contact|Currency|Subsidiary;


public type AddRequest record {
    Customer|Contact|Currency|Subsidiary addRequest;
};