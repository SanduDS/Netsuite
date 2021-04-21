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

# HTTP Client for NetSuite SOAP web service
#
# + basicClient - NetSuite HTTP Client  
public client class Client {
    public http:Client basicClient;
    private NetSuiteConfiguration config;

    public function init(NetSuiteConfiguration config)returns error? {
        self.config = config;
        self.basicClient = check new (config.baseURL);
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + customer - Details of NetSuite record instance creation
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error
    remote function addNewCustomer(Customer customer) returns RecordAddResponse|error{
        xml payload = check buildAddRecordPayload(customer, CUSTOMER, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + contact - Details of NetSuite record instance creation
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error
    remote function addNewContact(Contact contact) returns RecordAddResponse|error{
        xml payload = check buildAddRecordPayload(contact, CONTACT, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + invoice - Invoice type record with detail
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error  
    remote function addNewInvoice(Invoice invoice) returns RecordAddResponse|error{
        xml payload = check buildAddRecordPayload(invoice, INVOICE, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + currency - Currency type record with detail
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error 
    remote function addNewCurrency(Currency currency) returns RecordAddResponse|error{
        xml payload = check buildAddRecordPayload(currency, CURRENCY, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + salesOrder - SalesOrder type record with detail
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error 
    remote function addNewSalesOrder(SalesOrder salesOrder) returns RecordAddResponse|error{
        xml payload = check buildAddRecordPayload(salesOrder, SALES_ORDER, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + classification - Classification type record with detail
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error
    remote function addNewClassification(Classification classification) returns RecordAddResponse|error {
        xml payload = check buildAddRecordPayload(classification, CLASSIFICATION, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation creates a record instance in NetSuite according to the given detail
    #
    # + account - Account type record with detail
    # + return - If success returns a RecordCreationResponse type record otherwise the relevant error
    remote function addNewAccount(Account account) returns RecordAddResponse|error {
        xml payload = check buildAddRecordPayload(account, ACCOUNT, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, ADD_SOAP_ACTION, payload);
        return getRecordCreateResponse(response); 
    }

    # This remote operation deletes a record instance from NetSuite according to the given detail if they are valid.
    #
    # + info - Details of NetSuite record instance to be deleted
    # + return - If success returns a RecordDeletionResponse type record otherwise the relevant error
    remote function deleteRecord(RecordDetail info) returns @tainted RecordDeletionResponse|error{
        xml payload = check buildDeleteRecordPayload(info, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, DELETE_SOAP_ACTION, payload);
        return getRecordDeleteResponse(response); 
    }
    
    # Updates a NetSuite customer instance by internalId
    #
    # + customer - Customer record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error   
    remote function updateCustomerRecord(Customer customer) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecordPayload(customer, CUSTOMER , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }

    # Updates a NetSuite contact instance by internalId
    #
    # + contact - Contact record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    remote function updateContactRecord(Contact contact) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecordPayload(contact, CONTACT , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }
    
    # Updates a NetSuite currency instance by internalId
    #
    # + currency - Currency record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    remote function updateCurrencyRecord(Currency currency) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecordPayload(currency, CURRENCY , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }

    # Updates a NetSuite invoice instance by internalId
    #
    # + invoice - Invoice record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    remote function updateInvoiceRecord(Invoice invoice) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecordPayload(invoice, INVOICE , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }

    # Updates a NetSuite salesOrder instance by internalId
    #
    # + salesOrder - SalesOrder record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    remote function updateSalesOrderRecord(SalesOrder salesOrder) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecordPayload(salesOrder, SALES_ORDER , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }

    # Updates a NetSuite classification instance by internalId
    #
    # + classification - Classification record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    remote function updateClassificationRecord(Classification classification) returns @tainted RecordUpdateResponse|
                                                error {
        xml payload = check buildUpdateRecordPayload(classification, CLASSIFICATION , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }

    # Updates a NetSuite Account instance by internalId
    #
    # + account - Account record with details and internalId
    # + return - If success returns a RecordUpdateResponse type record otherwise the relevant error 
    remote function updateAccountRecord(Account account) returns @tainted RecordUpdateResponse|error {
        xml payload = check buildUpdateRecordPayload(account, ACCOUNT , self.config);
        http:Response response = check doHTTPRequest(self.basicClient, UPDATE_SOAP_ACTION, payload);
        return getRecordUpdateResponse(response); 
    }

    # This remote operation retrieves instances from NetSuite according to a given type  if they are valid
    #
    # + recordInfo - A NetSuite record instance to be retrieved from NetSuite
    # + return - If success returns a json array otherwise the relevant error
    remote function getAll(RecordGetAllType recordInfo) returns @tainted json[]|error {
        xml payload = check buildGetAllPayload(recordInfo, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, GET_ALL_SOAP_ACTION, payload);
        return formatGetAllResponse(response);
    }

    # This remote operation retrieves a savedSearch type instance from NetSuite according to the given detail 
    # if they are valid
    #
    # + recordInfo - A NetSuite SavedSearch record type to be retrieved from NetSuite
    # + return - If success returns a json array otherwise the relevant error
    remote function getSavedSearch(RecordSaveSearchType recordInfo) returns @tainted json[]|error {
        xml payload = check buildGetSavedSearchPayload(recordInfo, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, GET_SAVED_SEARCH_SOAP_ACTION, payload);
        return getSavedSearchResponse(response);
    }

    # This remote operation retrieves NetSuite instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    remote function searchCustomerRecord(SearchElement[] searchElements) returns @tainted Customer|error {
        xml payload = check buildCustomerSearchPayload(self.config, searchElements);
        http:Response response = check doHTTPRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getCustomerSearchResult(response);
    }

    # This remote operation retrieves NetSuite account record instances from NetSuite according to the given detail 
    # if they are valid
    #
    # + searchElements - Details of a NetSuite record to be retrieved from NetSuite
    # + return - If success returns a json otherwise the relevant error
    remote function searchAccountRecord(SearchElement[] searchElements) returns @tainted Account|error {
        xml payload = check buildAccountSearchPayload(self.config, searchElements);
        http:Response response = check doHTTPRequest(self.basicClient, SEARCH_SOAP_ACTION, payload);
        return getAccountSearchResult(response);
    }

    remote function getCustomerRecord(RecordDetail RecordDetail) returns Customer|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(RecordDetail, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCustomerRecordGetOperationResult(response, CUSTOMER);
    }

    remote function getCurrencyRecord(RecordDetail RecordDetail) returns Currency|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(RecordDetail, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getCurrencyRecordGetOperationResult(response, CURRENCY);
    }

    remote function getClassificationRecord(RecordDetail RecordDetail) returns Classification|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(RecordDetail, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getClassificationRecordGetOperationResult(response, CLASSIFICATION);
    }
    remote function getInvoiceRecord(RecordDetail RecordDetail) returns Classification|error {
        http:Request request = new;
        xml payload = check buildGetOperationPayload(RecordDetail, self.config);
        http:Response response = check doHTTPRequest(self.basicClient, GET_SOAP_ACTION, payload);
        return getInvoiceRecordGetOperationResult(response, INVOICE);
    }
 }

# Configuration record for NetSuite
#
# + accountId - NetSuite account ID  
# + consumerSecret - Netsuite Integration App consumer secret
# + baseURL - Netsuite baseURL for web services   
# + consumerId - Netsuite Integration App consumer ID   
# + tokenSecret - Netsuite user role access secret 
# + token - Netsuite user role access token 
public type NetSuiteConfiguration record {
    string accountId;
    string consumerId;
    string consumerSecret;
    string tokenSecret;
    string token;
    string baseURL;
};
