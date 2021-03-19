// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/jsonutils;
import ballerina/log;

public type NetsuiteConfiguration record {
    string accountId;
    string consumerId;
    string consmerSecret;
    string tokenSecret;
    string token;
    string baseURL;
};

public client class Client {
    public http:Client basicClient;
    private NetsuiteConfiguration config;

    public function init(NetsuiteConfiguration config)returns error? {
        self.config = config;
        self.basicClient = check new (config.baseURL);
    }

    remote function getAll(GetAllRecordType recordType) returns json|error {
        http:Request request = new;
        xml payload = check buildGetAllPayload(recordType, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getAll");
        xml response = <xml>check self.basicClient->post("", request, xml);
        xml formatted = check formatRawXMLesponse(response);
        return check jsonutils:fromXML(formatted/**/<soapenv_Body>);
    }

    remote function getList(GetListReqestFeild|GetListReqestFeild[] requestRecords) returns GetListResponse|error {
        http:Request request = new;
        xml payload = check buildGetListPayload(requestRecords, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getList");
        xml response = <xml>check self.basicClient->post("", request, xml);
        xml formattedXML = check formatRawXMLesponse(response);
        json jsonValue = check jsonutils:fromXML(formattedXML/**/<soapenv_Body>);
        json formatted = check formatRawJsonResponse(jsonValue);
        log:print(formatted.toString());
        return mapGetListRespose(formatted);

    }

    remote function getSavedSearch(GetSaveSearchType recordtype) returns SavedSearchResult|error {
        http:Request request = new;
        xml payload = check builGetSavedSearchPayload(recordtype, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getSavedSearch");
        xml response = <xml>check self.basicClient->post("", request, xml);
        xml formattedXML = check formatRawXMLesponse(response);
        json jsonValue = check jsonutils:fromXML(formattedXML/**/<soapenv_Body>);
        json formatted = check formatRawJsonResponse(jsonValue);
        return check mapSavedSearchRespose(formatted);
    }

    remote function customerSearch(SearchField[] searchData) returns json|error {
        http:Request request = new;
        xml payload = check buildCustomerSearchPayload(self.config, searchData);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "search");
        xml response = <xml>check self.basicClient->post("", request, xml);
        xml formatted = check formatRawXMLesponse(response);
        return check jsonutils:fromXML(formatted/**/<soapenv_Body>);
    }

    remote function transactionSearch(SearchField[] searchData) returns json|error {
        http:Request request = new;
        xml payload = check buildTransactionSearchPayload(self.config, searchData);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "search");
        xml response = <xml>check self.basicClient->post("", request, xml);
        xml formatted = check formatRawXMLesponse(response);
        log:print(formatted.toString());
        return check jsonutils:fromXML(formatted/**/<soapenv_Body>);
    }

    remote function get(GetReqestFeild requestRecord) returns GetResponse|error {
        http:Request request = new;
        xml payload = check buildGetPayload(requestRecord, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "get");
        xml response = <xml>check self.basicClient->post("", request, xml);
        xml formattedXML = check formatRawXMLesponse(response);
        json jsonValue = check jsonutils:fromXML(formattedXML/**/<soapenv_Body>);
        json formatted = check formatRawJsonResponse(jsonValue);
        log:print(formatted.toString());
        return mapGetRespose(formatted);
    }

 }
