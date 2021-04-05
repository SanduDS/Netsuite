public type ContactAddressBook record {
    boolean defaultShipping?;
    boolean defaultBilling?;
    string label?;
    Address[] addressBookAddress?;
    string internalId?;
};

public type CustomerAddressbook record {
    *ContactAddressBook;
    boolean isResidential;

};

public type Subscription record {
    boolean subscribed;
    RecordRef subscription;
    string lastModifiedDate;
};

public type Category record {
    *RecordRef;
};

public type CustomerCurrency record {
    RecordRef currency?;
    decimal balance?;
    decimal consolBalance?;
    decimal depositBalance?;
    decimal consolDepositBalance?;
    decimal overdueBalance?;
    decimal consolOverdueBalance?;
    decimal unbilledOrders?;
    decimal consolUnbilledOrders?;
    boolean overrideCurrencyFormat?;
};



