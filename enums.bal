// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

public enum RecordCoreType {
    ACCOUNT = "account",
    ACCOUNTING_PERIOD = "accountingPeriod",
    ADV_INTER_COMPANY_JOURNAL_ENTRY = "advInterCompanyJournalEntry",
    ASSEMBLY_BUILD = "assemblyBuild",
    ASSEMBLY_UNBUILD = "assemblyUnbuild",
    ASSEMBLY_ITEM = "assemblyItem",
    BILLING_ACCOUNT = "billingAccount",
    BILLING_SCHEDULE = "billingSchedule",
    BIN = "bin",
    BIN_TRANSFER = "binTransfer",
    BIN_WORKSHEET = "binWorksheet",
    BOM = "bom",
    BOM_REVISION = "bomRevision",
    BUDGET = "budget",
    BUDGET_CATEGORY = "budgetCategory",
    CALENDAR_EVENT = "calendarEvent",
    CAMPAIGN = "campaign",
    CAMPAIGN_AUDIENCE = "campaignAudience",
    CAMPAIGN_CATEGORY = "campaignCategory",
    CAMPAIGN_CHANNEL = "campaignChannel",
    CAMPAIGN_FAMILY = "campaignFamily",
    CAMPAIGN_OFFER = "campaignOffer",
    CAMPAIGN_RESPONSE = "campaignResponse",
    CAMPAIGN_SEARCH_ENGINE = "campaignSearchEngine",
    CAMPAIGN_SUBSCRIPTION = "campaignSubscription",
    CAMPAIGN_VERTICAL = "campaignVertical",
    CASH_REFUND = "cashRefund",
    CASH_SALE = "cashSale",
    'CHECK = "check",
    CHARGE = "charge",
    CLASSIFICATION = "classification",
    CONSOLIDATED_EXCHANGE_RATE = "consolidatedExchangeRate",
    CONTACT = "contact",
    CONTACT_CATEGORY = "contactCategory",
    CONTACT_ROLE = "contactRole",
    COST_CATEGORY = "costCategory",
    COUPON_CODE = "couponCode",
    CREDIT_MEMO = "creditMemo",
    CRM_CUSTOM_FIELD = "crmCustomField",
    CURRENCY = "currency",
    CURRENCY_RATE = "currencyRate",
    CUSTOM_LIST = "customList",
    CUSTOM_PURCHASE = "customPurchase",
    CUSTOM_RECORD = "customRecord",
    CUSTOM_RECORD_CUSTOM_FIELD = "customRecordCustomField",
    CUSTOM_RECORD_TYPE = "customRecordType",
    CUSTOM_SALE = "customSale",
    CUSTOM_SEGMENT = "customSegment",
    CUSTOM_TRANSACTION = "customTransaction",
    CUSTOM_TRANSACTION_TYPE = "customTransactionType",
    CUSTOMER = "customer",
    CUSTOMER_CATEGORY = "customerCategory",
    CUSTOMER_DEPOSIT = "customerDeposit",
    CUSTOMER_MESSAGE = "customerMessage",
    CUSTOMER_PAYMENT = "customerPayment",
    CUSTOMER_REFUND = "customerRefund",
    CUSTOMER_STATUS = "customerStatus",
    CUSTOMER_SUBSIDIARY_RELATIONSHIP = "customerSubsidiaryRelationship",
    DEPOSIT = "deposit",
    DEPOSIT_APPLICATION = "depositApplication",
    DEPARTMENT = "department",
    DESCRIPTION_ITEM = "descriptionItem",
    DISCOUNT_ITEM = "discountItem",
    DOWNLOAD_ITEM = "downloadItem",
    EMPLOYEE = "employee",
    ENTITY_CUSTOM_FIELD = "entityCustomField",
    ENTITY_GROUP = "entityGroup",
    ESTIMATE = "estimate",
    EXPENSE_CATEGORY = "expenseCategory",
    EXPENSE_REPORT = "expenseReport",
    FAIR_VALUE_PRICE = "fairValuePrice",
    FILE = "file",
    FOLDER = "folder",
    GENERAL_TOKEN = "generalToken",
    GIFT_CERTIFICATE = "giftCertificate",
    GIFT_CERTIFICATE_ITEM = "giftCertificateItem",
    GLOBAL_ACCOUNT_MAPPING = "globalAccountMapping",
    HCM_JOB = "hcmJob",
    IN_BOUND_SHIPMENT = "inboundShipment",
    INTERCOMPANYJOURNALENTRY = "interCompanyJournalEntry",
    INTERCOMPANYTRANSFERORDER = "interCompanyTransferOrder",
    INVENTORYADJUSTMENT = "inventoryAdjustment",
    INVENTORYCOSTREVALUATION = "inventoryCostRevaluation",
    INVENTORYITEM = "inventoryItem",
    INVENTORYNUMBER = "inventoryNumber",
    INVENTORYTRANSFER = "inventoryTransfer",
    INVOICE = "invoice",
    ITEMACCOUNTMAPPING = "itemAccountMapping",
    ITEMCUSTOMFIELD = "itemCustomField",
    ITEMDEMANDPLAN = "itemDemandPlan",
    ITEMFULFILLMENT = "itemFulfillment",
    ITEMGROUP = "itemGroup",
    ITEMNUMBERCUSTOMFIELD = "itemNumberCustomField",
    ITEMOPTIONCUSTOMFIELD = "itemOptionCustomField",
    ITEMSUPPLYPLAN = "itemSupplyPlan",
    ITEMREVISION = "itemRevision",
    ISSUE = "issue",
    JOB = "job",
    JOBSTATUS = "jobStatus",
    JOBTYPE = "jobType",
    ITEMRECEIPT = "itemReceipt",
    JOURNALENTRY = "journalEntry",
    KITITEM = "kitItem",
    LEADSOURCE = "leadSource",
    LOCATION = "location",
    LOTNUMBEREDINVENTORYITEM = "lotNumberedInventoryItem",
    LOTNUMBEREDASSEMBLYITEM = "lotNumberedAssemblyItem",
    MARKUPITEM = "markupItem",
    MERCHANDISEHIERARCHYNODE = "merchandiseHierarchyNode",
    MESSAGE = "message",
    MANUFACTURINGCOSTTEMPLATE = "manufacturingCostTemplate",
    MANUFACTURINGOPERATIONTASK = "manufacturingOperationTask",
    MANUFACTURINGROUTING = "manufacturingRouting",
    NEXUS = "nexus",
    NONINVENTORYPURCHASEITEM = "nonInventoryPurchaseItem",
    NONINVENTORYRESALEITEM = "nonInventoryResaleItem",
    NONINVENTORYSALEITEM = "nonInventorySaleItem",
    NOTE = "note",
    NOTETYPE = "noteType",
    OPPORTUNITY = "opportunity",
    OTHERCHARGEPURCHASEITEM = "otherChargePurchaseItem",
    OTHERCHARGERESALEITEM = "otherChargeResaleItem",
    OTHERCHARGESALEITEM = "otherChargeSaleItem",
    OTHERCUSTOMFIELD = "otherCustomField",
    OTHERNAMECATEGORY = "otherNameCategory",
    PARTNER = "partner",
    PARTNERCATEGORY = "partnerCategory",
    PAYCHECK = "paycheck",
    PAYCHECKJOURNAL = "paycheckJournal",
    PAYMENTCARD = "paymentCard",
    PAYMENTCARDTOKEN = "paymentCardToken",
    PAYMENTITEM = "paymentItem",
    PAYMENTMETHOD = "paymentMethod",
    PAYROLLITEM = "payrollItem",
    PERIODENDJOURNAL = "periodEndJournal",
    PHONECALL = "phoneCall",
    PRICELEVEL = "priceLevel",
    PRICINGGROUP = "pricingGroup",
    PROJECTTASK = "projectTask",
    PROMOTIONCODE = "promotionCode",
    PURCHASEORDER = "purchaseOrder",
    PURCHASEREQUISITION = "purchaseRequisition",
    RESOURCEALLOCATION = "resourceAllocation",
    RETURNAUTHORIZATION = "returnAuthorization",
    REVRECSCHEDULE = "revRecSchedule",
    REVRECTEMPLATE = "revRecTemplate",
    SALES_ORDER = "salesOrder",
    SALESROLE = "salesRole",
    SALESTAXITEM = "salesTaxItem",
    SERIALIZEDINVENTORYITEM = "serializedInventoryItem",
    SERIALIZEDASSEMBLYITEM = "serializedAssemblyItem",
    SERVICEPURCHASEITEM = "servicePurchaseItem",
    SERVICERESALEITEM = "serviceResaleItem",
    SERVICESALEITEM = "serviceSaleItem",
    SOLUTION = "solution",
    SITECATEGORY = "siteCategory",
    STATE = "state",
    STATISTICALJOURNALENTRY = "statisticalJournalEntry",
    SUBSIDIARY = "subsidiary",
    SUBTOTALITEM = "subtotalItem",
    SUPPORTCASE = "supportCase",
    SUPPORTCASEISSUE = "supportCaseIssue",
    SUPPORTCASEORIGIN = "supportCaseOrigin",
    SUPPORTCASEPRIORITY = "supportCasePriority",
    SUPPORTCASESTATUS = "supportCaseStatus",
    SUPPORTCASETYPE = "supportCaseType",
    TASK = "task",
    TAXACCT = "taxAcct",
    TAXGROUP = "taxGroup",
    TAXTYPE = "taxType",
    TERM = "term",
    TIMEBILL = "timeBill",
    TIMESHEET = "timeSheet",
    TOPIC = "topic",
    TRANSFERORDER = "transferOrder",
    TRANSACTIONBODYCUSTOMFIELD = "transactionBodyCustomField",
    TRANSACTIONCOLUMNCUSTOMFIELD = "transactionColumnCustomField",
    UNITSTYPE = "unitsType",
    USAGE = "usage",
    VENDOR = "vendor",
    VENDOR_CATEGORY = "vendorCategory",
    VENDOR_BILL = "vendorBill",
    VENDOR_CREDIT = "vendorCredit",
    VENDOR_PAYMENT = "vendorPayment",
    VENDOR_RETURN_AUTHORIZATION = "vendorReturnAuthorization",
    VENDOR_SUBSIDIARY_RELATIONSHIP = "vendorSubsidiaryRelationship",
    WIN_LOSS_REASON = "winLossReason",
    WORK_ORDER = "workOrder",
    WORK_ORDER_ISSUE = "workOrderIssue",
    WORK_ORDER_COMPLETION = "workOrderCompletion",
    WORK_ORDER_CLOSE = "workOrderClose"
}

// //-------------------------------------------------------------------------------------------------
// //CommonType enums

public enum GlobalSubscriptionStatusType {
    confirmedOptIn = "_confirmedOptIn",
    confirmedOptOut = "_confirmedOptOut",
    softOptIn = "_softOptIn",
    softOptOut = "_softOptOut"
}

public enum SalesOrderOrderStatus {
    pendingApproval = "_pendingApproval",
    pendingFulfillment = "_pendingFulfillment",
    cancelled = "_cancelled",
    partiallyFulfilled = "_partiallyFulfilled",
    pendingBillingPartFulfilled = "_pendingBillingPartFulfilled",
    pendingBilling = "_pendingBilling",
    fullyBilled = "_fullyBilled",
    closed = "_closed",
    undefined = "_undefined"
}

public enum Country {
    afghanistan = "_afghanistan",
    alandIslands = "_alandIslands",
    albania = "_albania",
    algeria = "_algeria",
    americanSamoa = "_americanSamoa",
    andorra = "_andorra",
    angola = "_angola",
    anguilla = "_anguilla",
    antarctica = "_antarctica",
    antiguaAndBarbuda = "_antiguaAndBarbuda",
    argentina = "_argentina",
    armenia = "_armenia",
    aruba = "_aruba",
    australia = "_australia",
    austria = "_austria",
    azerbaijan = "_azerbaijan",
    bahamas = "_bahamas",
    bahrain = "_bahrain",
    bangladesh = "_bangladesh",
    barbados = "_barbados",
    belarus = "_belarus",
    belgium = "_belgium",
    belize = "_belize",
    benin = "_benin",
    bermuda = "_bermuda",
    bhutan = "_bhutan",
    bolivia = "_bolivia",
    bonaireSaintEustatiusAndSaba = "_bonaireSaintEustatiusAndSaba",
    bosniaAndHerzegovina = "_bosniaAndHerzegovina",
    botswana = "_botswana",
    bouvetIsland = "_bouvetIsland",
    brazil = "_brazil",
    britishIndianOceanTerritory = "_britishIndianOceanTerritory",
    bruneiDarussalam = "_bruneiDarussalam",
    bulgaria = "_bulgaria",
    burkinaFaso = "_burkinaFaso",
    burundi = "_burundi",
    cambodia = "_cambodia",
    cameroon = "_cameroon",
    canada = "_canada",
    canaryIslands = "_canaryIslands",
    capeVerde = "_capeVerde",
    caymanIslands = "_caymanIslands",
    centralAfricanRepublic = "_centralAfricanRepublic",
    ceutaAndMelilla = "_ceutaAndMelilla",
    chad = "_chad",
    chile = "_chile",
    china = "_china",
    christmasIsland = "_christmasIsland",
    cocosKeelingIslands = "_cocosKeelingIslands",
    colombia = "_colombia",
    comoros = "_comoros",
    congoDemocraticPeoplesRepublic = "_congoDemocraticPeoplesRepublic",
    congoRepublicOf = "_congoRepublicOf",
    cookIslands = "_cookIslands",
    costaRica = "_costaRica",
    coteDIvoire = "_coteDIvoire",
    croatiaHrvatska = "_croatiaHrvatska",
    cuba = "_cuba",
    curacao = "_curacao",
    cyprus = "_cyprus",
    czechRepublic = "_czechRepublic",
    denmark = "_denmark",
    djibouti = "_djibouti",
    dominica = "_dominica",
    dominicanRepublic = "_dominicanRepublic",
    eastTimor = "_eastTimor",
    ecuador = "_ecuador",
    egypt = "_egypt",
    elSalvador = "_elSalvador",
    equatorialGuinea = "_equatorialGuinea",
    eritrea = "_eritrea",
    estonia = "_estonia",
    ethiopia = "_ethiopia",
    falklandIslands = "_falklandIslands",
    faroeIslands = "_faroeIslands",
    fiji = "_fiji",
    finland = "_finland",
    france = "_france",
    frenchGuiana = "_frenchGuiana",
    frenchPolynesia = "_frenchPolynesia",
    frenchSouthernTerritories = "_frenchSouthernTerritories",
    gabon = "_gabon",
    gambia = "_gambia",
    georgia = "_georgia",
    germany = "_germany",
    ghana = "_ghana",
    gibraltar = "_gibraltar",
    greece = "_greece",
    greenland = "_greenland",
    grenada = "_grenada",
    guadeloupe = "_guadeloupe",
    guam = "_guam",
    guatemala = "_guatemala",
    guernsey = "_guernsey",
    guinea = "_guinea",
    guineaBissau = "_guineaBissau",
    guyana = "_guyana",
    haiti = "_haiti",
    heardAndMcDonaldIslands = "_heardAndMcDonaldIslands",
    holySeeCityVaticanState = "_holySeeCityVaticanState",
    honduras = "_honduras",
    hongKong = "_hongKong",
    hungary = "_hungary",
    iceland = "_iceland",
    india = "_india",
    indonesia = "_indonesia",
    iranIslamicRepublicOf = "_iranIslamicRepublicOf",
    iraq = "_iraq",
    ireland = "_ireland",
    isleOfMan = "_isleOfMan",
    israel = "_israel",
    italy = "_italy",
    jamaica = "_jamaica",
    japan = "_japan",
    jersey = "_jersey",
    jordan = "_jordan",
    kazakhstan = "_kazakhstan",
    kenya = "_kenya",
    kiribati = "_kiribati",
    koreaDemocraticPeoplesRepublic = "_koreaDemocraticPeoplesRepublic",
    koreaRepublicOf = "_koreaRepublicOf",
    kosovo = "_kosovo",
    kuwait = "_kuwait",
    kyrgyzstan = "_kyrgyzstan",
    laoPeoplesDemocraticRepublic = "_laoPeoplesDemocraticRepublic",
    latvia = "_latvia",
    lebanon = "_lebanon",
    lesotho = "_lesotho",
    liberia = "_liberia",
    libya = "_libya",
    liechtenstein = "_liechtenstein",
    lithuania = "_lithuania",
    luxembourg = "_luxembourg",
    macau = "_macau",
    macedonia = "_macedonia",
    madagascar = "_madagascar",
    malawi = "_malawi",
    malaysia = "_malaysia",
    maldives = "_maldives",
    mali = "_mali",
    malta = "_malta",
    marshallIslands = "_marshallIslands",
    martinique = "_martinique",
    mauritania = "_mauritania",
    mauritius = "_mauritius",
    mayotte = "_mayotte",
    mexico = "_mexico",
    micronesiaFederalStateOf = "_micronesiaFederalStateOf",
    moldovaRepublicOf = "_moldovaRepublicOf",
    monaco = "_monaco",
    mongolia = "_mongolia",
    montenegro = "_montenegro",
    montserrat = "_montserrat",
    morocco = "_morocco",
    mozambique = "_mozambique",
    myanmar = "_myanmar",
    namibia = "_namibia",
    nauru = "_nauru",
    nepal = "_nepal",
    netherlands = "_netherlands",
    newCaledonia = "_newCaledonia",
    newZealand = "_newZealand",
    nicaragua = "_nicaragua",
    niger = "_niger",
    nigeria = "_nigeria",
    niue = "_niue",
    norfolkIsland = "_norfolkIsland",
    northernMarianaIslands = "_northernMarianaIslands",
    norway = "_norway",
    oman = "_oman",
    pakistan = "_pakistan",
    palau = "_palau",
    panama = "_panama",
    papuaNewGuinea = "_papuaNewGuinea",
    paraguay = "_paraguay",
    peru = "_peru",
    philippines = "_philippines",
    pitcairnIsland = "_pitcairnIsland",
    poland = "_poland",
    portugal = "_portugal",
    puertoRico = "_puertoRico",
    qatar = "_qatar",
    reunionIsland = "_reunionIsland",
    romania = "_romania",
    russianFederation = "_russianFederation",
    rwanda = "_rwanda",
    saintBarthelemy = "_saintBarthelemy",
    saintHelena = "_saintHelena",
    saintKittsAndNevis = "_saintKittsAndNevis",
    saintLucia = "_saintLucia",
    saintMartin = "_saintMartin",
    saintVincentAndTheGrenadines = "_saintVincentAndTheGrenadines",
    samoa = "_samoa",
    sanMarino = "_sanMarino",
    saoTomeAndPrincipe = "_saoTomeAndPrincipe",
    saudiArabia = "_saudiArabia",
    senegal = "_senegal",
    serbia = "_serbia",
    seychelles = "_seychelles",
    sierraLeone = "_sierraLeone",
    singapore = "_singapore",
    sintMaarten = "_sintMaarten",
    slovakRepublic = "_slovakRepublic",
    slovenia = "_slovenia",
    solomonIslands = "_solomonIslands",
    somalia = "_somalia",
    southAfrica = "_southAfrica",
    southGeorgia = "_southGeorgia",
    southSudan = "_southSudan",
    spain = "_spain",
    sriLanka = "_sriLanka",
    stateOfPalestine = "_stateOfPalestine",
    stPierreAndMiquelon = "_stPierreAndMiquelon",
    sudan = "_sudan",
    suriname = "_suriname",
    svalbardAndJanMayenIslands = "_svalbardAndJanMayenIslands",
    swaziland = "_swaziland",
    sweden = "_sweden",
    switzerland = "_switzerland",
    syrianArabRepublic = "_syrianArabRepublic",
    taiwan = "_taiwan",
    tajikistan = "_tajikistan",
    tanzania = "_tanzania",
    thailand = "_thailand",
    togo = "_togo",
    tokelau = "_tokelau",
    tonga = "_tonga",
    trinidadAndTobago = "_trinidadAndTobago",
    tunisia = "_tunisia",
    turkey = "_turkey",
    turkmenistan = "_turkmenistan",
    turksAndCaicosIslands = "_turksAndCaicosIslands",
    tuvalu = "_tuvalu",
    uganda = "_uganda",
    ukraine = "_ukraine",
    unitedArabEmirates = "_unitedArabEmirates",
    unitedKingdom = "_unitedKingdom",
    unitedStates = "_unitedStates",
    uruguay = "_uruguay",
    uSMinorOutlyingIslands = "_uSMinorOutlyingIslands",
    uzbekistan = "_uzbekistan",
    vanuatu = "_vanuatu",
    venezuela = "_venezuela",
    vietnam = "_vietnam",
    virginIslandsBritish = "_virginIslandsBritish",
    virginIslandsUSA = "_virginIslandsUSA",
    wallisAndFutunaIslands = "_wallisAndFutunaIslands",
    westernSahara = "_westernSahara",
    yemen = "_yemen",
    zambia = "_zambia",
    zimbabwe = "_zimbabwe"
}
///////////////////////////////////get functions///////////////////////////////
public enum GetAllRecordType {
    BUDGETCATEGORY = "budgetCategory",
    CAMPAIGNAUDIENCE = "campaignAudience",
    CURRENCY_All_TYPES = "currency",
    STATE_All_TYPES = "state",
    TAX_ACCT = "taxAcct"
}

////////getSaveSearch////////////////////////////////////////////////////////////
public enum GetSaveSearchType {
    ACCOUNT_SAVED_SEARCH = "account",
    ACCOUNTINGPERIOD = "accountingPeriod",
    ACCOUNTINGTRANSACTION = "accountingTransaction",
    BILLINGACCOUNT = "billingAccount",
    BILLINGSCHEDULE = "billingSchedule",
    BIN_SAVED_SEARCH = "bin",
    BOM_SAVED_SEARCH = "bom",
    BOMREVISION = "bomRevision",
    BUDGET_SAVED_SEARCH = "budget",
    CALENDAREVENT = "calendarEvent",
    CAMPAIGN_SAVED_SEARCH = "campaign",
    CHARGE_SAVED_SEARCH = "charge",
    CLASSIFICATION_SAVED_SEARCH = "classification",
    CONTACT_SAVED_SEARCH = "contact",
    CONTACTCATEGORY = "contactCategory",
    CONTACTROLE = "contactRole",
    COSTCATEGORY = "costCategory",
    CONSOLIDATEDEXCHANGERATE = "consolidatedExchangeRate",
    COUPONCODE = "couponCode",
    CURRENCYRATE = "currencyRate",
    CUSTOMER_SAVED_SEARCH = "customer",
    CUSTOMERCATEGORY = "customerCategory",
    CUSTOMERMESSAGE = "customerMessage",
    CUSTOMERSTATUS = "customerStatus",
    CUSTOMERSUBSIDIARYRELATIONSHIP = "customerSubsidiaryRelationship",
    CUSTOMLIST = "customList",
    CUSTOMRECORD = "customRecord",
    DEPARTMENT_SAVED_SEARCH = "department",
    EMPLOYEE_SAVED_SEARCH = "employee",
    ENTITYGROUP = "entityGroup",
    EXPENSECATEGORY = "expenseCategory",
    FAIRVALUEPRICE = "fairValuePrice",
    FILE_SAVED_SEARCH = "file",
    FOLDER_SAVED_SEARCH = "folder",
    GIFTCERTIFICATE = "giftCertificate",
    GLOBALACCOUNTMAPPING = "globalAccountMapping",
    HCMJOB = "hcmJob",
    INBOUNDSHIPMENT = "inboundShipment",
    INVENTORYNUMBER_SAVED_SEARCH = "inventoryNumber",
    ITEM = "item",
    ITEMACCOUNTMAPPING_SAVED_SEARCH = "itemAccountMapping",
    ITEMDEMANDPLAN_SAVED_SEARCH = "itemDemandPlan",
    ITEMREVISION_SAVED_SEARCH = "itemRevision",
    ITEMSUPPLYPLAN_SAVED_SEARCH = "itemSupplyPlan",
    ISSUE_SAVED_SEARCH = "issue",
    JOB_SAVED_SEARCH = "job",
    JOBSTATUS_SAVED_SEARCH = "jobStatus",
    JOBTYPE_SAVED_SEARCH = "jobType",
    LOCATION_SAVED_SEARCH = "location",
    MANUFACTURINGCOSTTEMPLATE_SAVED_SEARCH = "manufacturingCostTemplate",
    MANUFACTURINGOPERATIONTASK_SAVED_SEARCH = "manufacturingOperationTask",
    MANUFACTURINGROUTING_SAVED_SEARCH = "manufacturingRouting",
    MERCHANDISEHIERARCHYNODE_SAVED_SEARCH = "merchandiseHierarchyNode",
    MESSAGE_SAVED_SEARCH = "message",
    NEXUS_SAVED_SEARCH = "nexus",
    NOTE_SAVED_SEARCH = "note",
    NOTETYPE_SAVED_SEARCH = "noteType",
    OPPORTUNITY_SAVED_SEARCH = "opportunity",
    OTHER_NAME_CATEGORY_SAVED_SEARCH = "otherNameCategory",
    PARTNER_SAVED_SEARCH = "partner",
    PARTNER_CATEGORY_SAVED_SEARCH = "partnerCategory",
    PAY_CHECK_SAVED_SEARCH = "paycheck",
    PAYMENT_METHOD_SAVED_SEARCH = "paymentMethod",
    PAYROLL_ITEM_SAVED_SEARCH = "payrollItem",
    PHONE_CALL_SAVED_SEARCH = "phoneCall",
    PRICE_LEVEL_SAVED_SEARCH = "priceLevel",
    PRICING_GROUP_SAVED_SEARCH = "pricingGroup",
    PROJECT_TASK_SAVED_SEARCH = "projectTask",
    PROMOTION_CODE_SAVED_SEARCH = "promotionCode",
    RESOURCE_ALLOCATION_SAVED_SEARCH = "resourceAllocation",
    REV_REC_SCHEDULE_SAVED_SEARCH = "revRecSchedule",
    REV_RECT_EMPLATE_SAVED_SEARCH = "revRecTemplate",
    SALES_ROLE_SAVED_SEARCH = "salesRole",
    SALES_TAX_ITEM_SAVED_SEARCH = "salesTaxItem",
    SOLUTION_SAVED_SEARCH = "solution",
    SITE_CATEGORY_SAVED_SEARCH = "siteCategory",
    SUBSIDIARY_SAVED_SEARCH = "subsidiary",
    SUPPORT_CASE_SAVED_SEARCH = "supportCase",
    TASK_SAVED_SEARCH = "task",
    TAX_GROUP_SAVED_SEARCH = "taxGroup",
    TAX_TYPE_SAVED_SEARCH = "taxType",
    TERM_SAVED_SEARCH = "term",
    TIMEBILL_SAVED_SEARCH = "timeBill",
    TIME_SHEET_SAVED_SEARCH = "timeSheet",
    TOPIC_SAVED_SEARCH = "topic",
    TRANSACTION = "transaction",
    UNITSTYPE_SAVED_SEARCH = "unitsType",
    USAGE_SAVED_SEARCH = "usage",
    VENDOR_SAVED_SEARCH = "vendor",
    VENDOR_CATEGORY_SAVED_SEARCH = "vendorCategory",
    VENDOR_SUBSIDIARY_RELATIONSHIP__SAVED_SEARCH = "vendorSubsidiaryRelationship"
}

/////////////////////////////Enum for searching////////////////////////////////////////
public enum CustomerSearchElement {
    ACCOUN_TNUMBER = "accountNumber",
    ADDRESS = "address",
    ADDRESSEE = "addressee",
    ADDRESS_LABEL = "addressLabel",
    ADDRESS_PHONE = "addressPhone",
    ASSIGNED_SITE = "assignedSite",
    ASSIGNED_SITEID = "assignedSiteId",
    ATTENTION = "attention",
    AVAILABLE_OFFLINE = "availableOffline",
    BALANCE = "balance",
    BILLADDRESS = "billAddress",
    BOUGHTAMOUNT = "boughtAmount",
    BOUGHTDATE = "boughtDate",
    BUYINGREASON = "buyingReason",
    BUYINGTIMEFRAME = "buyingTimeFrame",
    CATEGORY = "category",
    CCCUSTOMERCODE = "ccCustomerCode",
    CCDEFAULT = "ccDefault",
    CCEXPDATE = "ccExpDate",
    CCHOLDERNAME = "ccHolderName",
    CCNUMBER = "ccNumber",
    CCSTATE = "ccState",
    CCSTATEFROM = "ccStateFrom",
    CCTYPE = "ccType",
    CITY = "city",
    CLASSBOUGHT = "classBought",
    COMMENTS = "comments",
    COMPANYNAME = "companyName",
    CONSOLBALANCE = "consolBalance",
    CONSOLDAYSOVERDUE = "consolDaysOverdue",
    CONSOLDEPOSITBALANCE = "consolDepositBalance",
    CONSOLOVERDUEBALANCE = "consolOverdueBalance",
    CONSOLUNBILLEDORDERS = "consolUnbilledOrders",
    CONTACT_SEARCH = "contact",
    CONTRIBUTION = "contribution",
    CONVERSIONDATE = "conversionDate",
    COUNTRY = "country",
    COUNTY = "county",
    CREDITHOLD = "creditHold",
    CREDITHOLDOVERRIDE = "creditHoldOverride",
    CREDITLIMIT = "creditLimit",
    CURRENCY__SEARCH = "currency",
    CUSTSTAGE = "custStage",
    CUSTSTATUS = "custStatus",
    DATECLOSED = "dateClosed",
    DATECREATED = "dateCreated",
    DAYSOVERDUE = "daysOverdue",
    DEFAULTORDERPRIORITY = "defaultOrderPriority",
    DEFAULTTAXREG = "defaultTaxReg",
    DEFAULTTAXREGTEXT = "defaultTaxRegText",
    DEPOSITBALANCE = "depositBalance",
    DEPTBOUGHT = "deptBought",
    DRACCOUNT = "drAccount",
    EMAIL = "email",
    EMAILPREFERENCE = "emailPreference",
    EMAILTRANSACTIONS = "emailTransactions",
    ENDDATE = "endDate",
    ENTITYID = "entityId",
    ENTITYSTATUS = "entityStatus",
    ESTIMATEDBUDGET = "estimatedBudget",
    EXPLICITCONVERSION = "explicitConversion",
    EXTERNALID = "externalId",
    EXTERNALIDSTRING = "externalIdString",
    FAX = "fax",
    FAXTRANSACTIONS = "faxTransactions",
    FIRSTNAME = "firstName",
    FIRSTORDERDATE = "firstOrderDate",
    FIRSTSALEDATE = "firstSaleDate",
    FXACCOUNT = "fxAccount",
    FXBALANCE = "fxBalance",
    FXCONSOLBALANCE = "fxConsolBalance",
    FXCONSOLUNBILLEDORDERS = "fxConsolUnbilledOrders",
    FXUNBILLEDORDERS = "fxUnbilledOrders",
    GIVEACCESS = "giveAccess",
    GLOBALSUBSCRIPTIONSTATUS = "globalSubscriptionStatus",
    GROUP = "group",
    GROUPPRICINGLEVEL = "groupPricingLevel",
    HASDUPLICATES = "hasDuplicates",
    IMAGE = "image",
    INTERNALID = "internalId",
    INTERNALIDNUMBER = "internalIdNumber",
    ISBUDGETAPPROVED = "isBudgetApproved",
    ISDEFAULTBILLING = "isDefaultBilling",
    ISDEFAULTSHIPPING = "isDefaultShipping",
    ISINACTIVE = "isInactive",
    ISPERSON = "isPerson",
    ISREPORTEDLEAD = "isReportedLead",
    ISSHIPADDRESS = "isShipAddress",
    ITEMPRICINGLEVEL = "itemPricingLevel",
    ITEMPRICINGUNITPRICE = "itemPricingUnitPrice",
    ITEMSBOUGHT = "itemsBought",
    ITEMSORDERED = "itemsOrdered",
    LANGUAGE = "language",
    LASTMODIFIEDDATE = "lastModifiedDate",
    LASTNAME = "lastName",
    LASTORDERDATE = "lastOrderDate",
    LASTSALEDATE = "lastSaleDate",
    LEADDATE = "leadDate",
    LEADSOURCE_SEARCH = "leadSource",
    LEVEL = "level",
    LOCATIONBOUGHT = "locationBought",
    MANUALCREDITHOLD = "manualCreditHold",
    MERCHANTACCOUNT = "merchantAccount",
    MIDDLENAME = "middleName",
    MONTHLYCLOSING = "monthlyClosing",
    ONCREDITHOLD = "onCreditHold",
    ORDEREDAMOUNT = "orderedAmount",
    ORDEREDDATE = "orderedDate",
    OTHERRELATIONSHIPS = "otherRelationships",
    OVERDUEBALANCE = "overdueBalance",
    PARENT = "parent",
    PARENTITEMSBOUGHT = "parentItemsBought",
    PARENTITEMSORDERED = "parentItemsOrdered",
    PARTNER_SEARCH = "partner",
    PARTNERCONTRIBUTION = "partnerContribution",
    PARTNERROLE = "partnerRole",
    PARTNERTEAMMEMBER = "partnerTeamMember",
    PEC = "pec",
    PERMISSION = "permission",
    PHONE = "phone",
    PHONETICNAME = "phoneticName",
    PRICELEVEL_SEARCH = "priceLevel",
    PRICINGGROUP_SEARCH = "pricingGroup",
    PRICINGITEM = "pricingItem",
    PRINTTRANSACTIONS = "printTransactions",
    PROSPECTDATE = "prospectDate",
    PSTEXEMPT = "pstExempt",
    RECEIVABLESACCOUNT = "receivablesAccount",
    REMINDERDATE = "reminderDate",
    RESALENUMBER = "resaleNumber",
    ROLE = "role",
    SALESREADINESS = "salesReadiness",
    SALESREP = "salesRep",
    SALESTEAMMEMBER = "salesTeamMember",
    SALESTEAMROLE = "salesTeamRole",
    SALUTATION = "salutation",
    SHIPADDRESS = "shipAddress",
    SHIPCOMPLETE = "shipComplete",
    SHIPPINGITEM = "shippingItem",
    SOURCESITE = "sourceSite",
    SOURCESITEID = "sourceSiteId",
    STAGE = "stage",
    STARTDATE = "startDate",
    STATE_SEARCH = "state",
    SUBSIDBOUGHT = "subsidBought",
    SUBSIDIARY_SEARCH = "subsidiary",
    TAXABLE = "taxable",
    TERMS = "terms",
    TERRITORY = "territory",
    TITLE = "title",
    UNBILLEDORDERS = "unbilledOrders",
    URL = "url",
    VATREGNUMBER = "vatRegNumber",
    WEBLEAD = "webLead",
    ZIPCODE = "zipCode"
}

public enum SearchDateFieldOperator {
    AFTER = "after",
    BEFORE = "before",
    EMPTY = "empty",
    NOTAFTER = "notAfter",
    NOTBEFORE = "notBefore",
    NOTEMPTY = "notEmpty",
    NOTON = "notOn",
    NOTONORAFTER = "notOnOrAfter",
    NOTONORBEFORE = "notOnOrBefore",
    NOTWITHIN = "notWithin",
    ON = "on",
    ONORAFTER = "onOrAfter",
    ONORBEFORE = "onOrBefore",
    WITHIN = "within"
}

public enum SearchDoubleFieldOperator {
    BETWEEN_DFIELD = "between",
    EMPTY_DFIELD = "empty",
    EQUALTO_DFIELD = "equalTo",
    GREATERTHAN_DFIELD = "greaterThan",
    GREATERTHANOREQUALTO_DFIELD = "greaterThanOrEqualTo",
    LESSTHAN_DFIELD = "lessThan",
    LESSTHANOREQUALTO_DFIELD = "lessThanOrEqualTo",
    NOTBETWEEN_DFIELD = "notBetween",
    NOTEMPTY_DFIELD = "notEmpty",
    NOTEQUALTO_DFIELD = "notEqualTo",
    NOTGREATERTHAN_DFIELD = "notGreaterThan",
    NOTGREATERTHANOREQUALTO_DFIELD = "notGreaterThanOrEqualTo",
    NOTLESSTHAN_DFIELD = "notLessThan",
    NOTLESSTHANOREQUALTO_DFIELD = "notLessThanOrEqualTo"
}

public enum BasicSearchStringFieldOperation {
    CONTAINS = "contains",
    DOESNOTCONTAIN = "doesNotContain",
    DOESNOTSTARTWITH = "doesNotStartWith",
    EMPTY_STRING_FIELD = "empty",
    HASKEYWORDS = "hasKeywords",
    IS = "is",
    ISNOT = "isNot",
    NOTEMPTY_STRING_FIELD = "notEmpty",
    STARTSWITH = "startsWith"
}

public enum BasicSearchEnumORMultiSelectFieldOperator {
    ANYOF = "anyOf",
    NONEOF = "noneOf"
}

public enum BasicSearchDoubleFieldOperator {
    BETWEEN = "between",
    EMPTY_DOUBLE_FIELD = "empty",
    EQUALTO = "equalTo",
    GREATERTHAN = "greaterThan",
    GREATERTHANOREQUALTO = "greaterThanOrEqualTo",
    LESSTHAN = "lessThan",
    LESSTHANOREQUALTO = "lessThanOrEqualTo",
    NOTBETWEEN = "notBetween",
    NOTEMPTY_DOUBLE_FIELD = "notEmpty",
    NOTEQUALTO = "notEqualTo",
    NOTGREATERTHAN = "notGreaterThan",
    NOTGREATERTHANOREQUALTO = "notGreaterThanOrEqualTo",
    NOTLESSTHAN = "notLessThan",
    NOTLESSTHANOREQUALTO = "notLessThanOrEqualTo"
}

public enum BasicSearchBooleanFieldOperator {
    TRUE = "true",
    FALSE = "false"
}

public enum BasicSearchDateFieldOperator {
    AFTER_DATE = "after",
    BEFORE_DATE = "before",
    EMPTY_DATE_FIELD = "empty",
    NOTAFTER_DATE = "notAfter",
    NOTBEFORE_DATE = "notBefore",
    NOTEMPTY_DATE_FIELD = "notEmpty",
    NOTON_DATE = "notOn",
    NOTONORAFTER_DATE = "notOnOrAfter",
    NOTONORBEFORE_DATE = "notOnOrBefore",
    NOTWITHIN_DATES= "notWithin",
    ON_DATE = "on",
    ONORAFTER_DATE = "onOrAfter",
    ONORBEFORE_DATE = "onOrBefore",
    WITHIN_DATES = "within"
}

public enum RecordSearchType {
    CUSTOMER_TYPE
}