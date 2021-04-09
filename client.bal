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

import ballerina/http;

public client class Client {
    public http:Client basicClient;
    private NetsuiteConfiguration config;

    public function init(NetsuiteConfiguration config)returns error? {
        self.config = config;
        self.basicClient = check new (config.baseURL);
    }

    remote function addNewRecord(RecordCreationInfo recordCreationInfo) returns RecordCreationResponse|error {
        http:Request request = new;
        xml payload = check buildAddRecordPayload(recordCreationInfo, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatInstanceCreationResponse(response); 
    }

    remote function deleteRecord(RecordDeletionInfo info) returns RecordDeletionResponse|error{
        http:Request request = new;
        xml payload = check buildDeleteRecordPayload(info, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "delete");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatDeleteResponse(response); 
    }

    remote function updateRecord(RecordUpdateInfo recordUpdateInfo) returns RecordUpdateResponse|error {
        http:Request request = new;
        xml payload = check buildUpdateRecordPayload(recordUpdateInfo, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "update");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatUpdateResponse(response); 
    }
    
    remote function getAll(GetAllRecordType recordType) returns json[]|error {
        http:Request request = new;
        xml payload = check buildGetAllPayload(recordType, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getAll");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatGetAllResponse(response);
    }
    remote function getSavedSearch(GetSaveSearchType recordType) returns json[]|error {
        http:Request request = new;
        xml payload = check buildGetSavedSearchPayload(recordType, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getSavedSearch");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatSavedSearchResponse(response);
    }
    remote function searchRecord(RecordSearchInfo searchInfo) returns json|error {
        http:Request request = new;
        xml payload = check buildSearchPayload(self.config, searchInfo);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "search");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatSearchResponse(response);
    }
 }

public type NetsuiteConfiguration record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string baseURL;
};

