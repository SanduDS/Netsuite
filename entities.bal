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