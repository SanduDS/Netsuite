public type ContactAddressBook record {
    boolean defaultShipping;
    boolean defaultBilling;
    string label;
    Address addressBookAddress;
    string internalId;

};

public type Subscription record {
    boolean subscribed;
    RecordRef subscription;
    string lastModifiedDate;
};

public type Customer record {
    string id;
};

