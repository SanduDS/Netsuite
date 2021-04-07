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

    remote function addNewRecord(AddRequest addRequest) returns AddRecordResponse|error {
        http:Request request = new;
        xml payload = check buildAddRecordPayload(addRequest, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatAddResponse(response); 
    }

    remote function deleteRecord(DeleteRequest deleteRequest) returns DeleteRecordResponse|error{
        http:Request request = new;
        xml payload = check buildDeleteRecordPayload(deleteRequest, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "delete");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatDeleteResponse(response); 
    }

    remote function updateRecord(UpdateRequest updateRequest) returns UpdateRecordResponse|error {
        http:Request request = new;
        xml payload = check buildUpdateRecordPayload(updateRequest, self.config);
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
 }

public type NetsuiteConfiguration record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string baseURL;
};

