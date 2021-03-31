public type RecordRef record {
    string name = "baseRef";
    string internalId;
    string externalId?;
    string 'type;
};

public type Category record {
    //*RecordRef;
    string name = "category";
};