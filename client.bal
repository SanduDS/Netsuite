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
//import ballerina/log;

# Description
#
# + basicClient - Netsuite HTTP Client  
public client class Client {
    public http:Client basicClient;
    private NetsuiteConfiguration config;

    public function init(NetsuiteConfiguration config)returns error? {
        self.config = config;
        self.basicClient = check new (config.baseURL);
    }

    # This remote operation creates a record instance in Netsuite according to the given detail if they are valid
    #
    # + customer - Details of netsuite record instance creation
    # + return - if success returns a RecordCreationResponse type record otherwise the relevant error
    remote function addNewCustomer(Customer customer) returns RecordAddResponse|error{
        http:Request request = new;
        xml payload = check buildAddRecordPayload(customer, CUSTOMER, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatInstanceCreationResponse(response); 
    }

    remote function addNewContact(Contact contact) returns RecordAddResponse|error{
        http:Request request = new;
        xml payload = check buildAddRecordPayload(contact, CONTACT, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatInstanceCreationResponse(response); 
    }

    remote function addNewInvoice(Invoice invoice) returns RecordAddResponse|error{
        http:Request request = new;
        xml payload = check buildAddRecordPayload(invoice, INVOICE, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatInstanceCreationResponse(response); 
    }

    remote function addNewCurrency(Currency currency) returns RecordAddResponse|error{
        http:Request request = new;
        xml payload = check buildAddRecordPayload(currency, CURRENCY, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatInstanceCreationResponse(response); 
    }

    remote function addNewSalesOrder(SalesOrder salesOrder) returns RecordAddResponse|error{
        http:Request request = new;
        xml payload = check buildAddRecordPayload(salesOrder, SALES_ORDER, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "add");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatInstanceCreationResponse(response); 
    }

    # This remote operation deletes a record instance from Netsuite according to the given detail if they are valid.
    #
    # + info - Details of netsuite record instance to be deleted
    # + return - if success returns a RecordDeletionResponse type record otherwise the relevant error
    remote function deleteRecord(RecordDetail info) returns @tainted RecordDeletionResponse|error{
        http:Request request = new;
        xml payload = check buildDeleteRecordPayload(info, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "delete");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatDeleteResponse(response); 
    }

    # This remote operation updates a record instance from Netsuite according to the given detail if they are valid
    #
    # + recordUpdateInfo - Details of netsuite record instance to be deleted
    # + return - if success returns a RecordUpdateResponse type record otherwise the relevant error
    remote function updateRecord(RecordUpdateInfo recordUpdateInfo) returns @tainted RecordUpdateResponse|error {
        http:Request request = new;
        xml payload = check buildUpdateRecordPayload(recordUpdateInfo, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "update");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatUpdateResponse(response); 
    }
    
    # This remote operation retrieves instances from Netsuite according to a given type  if they are valid
    #
    # + recordInfo - A Netsuite record instance to be retrieved from Netsuite
    # + return - If success returns a json array otherwise the relevant error
    remote function getAll(RecordGetAllType recordInfo) returns @tainted json[]|error {
        http:Request request = new;
        xml payload = check buildGetAllPayload(recordInfo, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getAll");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatGetAllResponse(response);
    }

    # This remote operation retrieves a savedSearch type instance from Netsuite according to the given detail 
    # if they are valid
    #
    # + recordInfo - A Netsuite SavedSearch record type to be retrieved from Netsuite
    # + return - If success returns a json array otherwise the relevant error
    remote function getSavedSearch(RecordSaveSearchType recordInfo) returns @tainted json[]|error {
        http:Request request = new;
        xml payload = check buildGetSavedSearchPayload(recordInfo, self.config);
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "getSavedSearch");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return formatSavedSearchResponse(response);
    }

    # This remote operation retrieves Netsuite instances from Netsuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a Netsuite record to be retrieved from Netsuite
    # + return - If success returns a json otherwise the relevant error
    remote function searchCustomerRecord(SearchElement[] searchElements) returns @tainted Customer|error {
        http:Request request = new;
        xml payload = check buildCustomerSearchPayload(self.config, searchElements);
        //log:print(payload.toString());
        request.setXmlPayload(payload);
        request.setHeader("SOAPAction", "search");
        http:Response response = <http:Response>check self.basicClient->post("", request);
        return getCustomerSearchResponse(response);
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
