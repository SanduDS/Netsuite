public type Classification record {
    string name?;
    boolean includeChildren?;
    RecordRef parent?;
    boolean isInactive?;
    RecordRef subsidiaryList?;
    string internalId?;
    string externalId?;
};
