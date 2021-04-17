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

public type TokenData record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string nounce;
    string timestamp;
};

public type RecordCreationInfo record {
    NetSuiteInstance instance;
    string recordType;
};

public type RecordAddResponse record {
    boolean isSuccess;
    boolean afterSubmitFailed?;
    string internalId;
    string recordType;
};

public type RecordDeletionResponse record {
    *RecordAddResponse;
};

public type RecordUpdateResponse record {
    *RecordAddResponse;
};

public type RecordDetail record {
    string recordInternalId;
    string recordType;
    string deletionReasonId?;
    string deletionReasonMemo?;
};

public type RecordUpdateInfo record {
    NetSuiteInstance instance;
    string internalId;
    RecordCoreType recordType;
};



public type SavedSearchResponse record {
    int numberOfRecords?;
    boolean isSuccess;
    RecordRef[] recordRefList = [];
};

public type DoubleField record {
    SearchDoubleFieldOperator operator;
    string searchValue;
    string searchValue2;
};

public type DateField record {
    SearchDateFieldOperator operator;
    string preDefinedDate?;
    string date?;
    string date2?;
};

public type NetSuiteInstance Customer|Contact|Currency|Invoice|Classification;// change names RecordTypes

type MapAnydata map<anydata>;
