public type Classification record {
    string name?;
    boolean includeChildren?;
    RecordRef parent?;
    boolean isInactive?;
    RecordRef subsidiaryList?;
    string internalId?;
    string externalId?;
};

public type Account record {
    string internalId?;
    string externalId?;   
    string acctType?;
    RecordRef unitsType?;
    RecordRef unit?;
    string acctNumber?;
    string acctName?;
    string legalName?;
    boolean includeChildren?;
    RecordRef currency?;
    string exchangeRate?;
    string generalRate?;
    RecordRef 'type?;
    ConsolidatedRate|string cashFlowRate?;
    RecordRef billableExpensesAcct?;
    RecordRef deferralAcct?;
    string description?;
    decimal curDocNum?;
    boolean isInactive?;
    RecordRef department?;
    RecordRef 'class?;
    RecordRef location?;
    boolean inventory?;
    boolean eliminate?;
    decimal openingBalance?;
    boolean revalue?;
    Subsidiary subsidiary?;
};