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

    remote function addNewRecordInstance(AddRecordType requestField) returns json|error? {
        http:Request request = new;
        xml payload = check buildAddRecordPayload(requestField, self.config);
        request.setXmlPayload(payload);
        //request.setHeader("SOAPAction", "getAll");
        //xml response = <xml>check self.basicClient->post("", request, xml);
        //xml formatted = check formatRawXMLResponse(response);
        //return check jsonutils:fromXML(formatted/**/<soapenv_Body>);
        return;
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

