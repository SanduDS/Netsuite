# Netsuite Connector
based on Netsuite SOAP webservice


[![CI](https://github.com/SanduDS/Netsuite/actions/workflows/ci.yml/badge.svg)](https://github.com/SanduDS/Netsuite/actions/workflows/ci.yml)
# Ballerina NetSuite Connector

This module allows you to access the NetSuite's SuiteTalk REST Web services API though Ballerina. NetSuite is used for 
Enterprise Resource Planning (ERP) and to manage inventory, track their financials, host e-commerce stores, and maintain 
Customer Relationship Management (CRM) systems. The NetSuite connector can execute CRUD (create, read, update, delete) 
and search operations to perform business processing on NetSuite records and to navigate dynamically between records.

The following sections provide you details on how to use the NetSuite connector.

- [Compatibility](#compatibility)
- [Feature Overview](#feature-overview)
- [Getting Started](#getting-started)

## Compatibility

|                             |           Version                    |
|:---------------------------:|:------------------------------------:|
| Ballerina Language          |     Swan Lake Alpha2                 |
| NetSuite SOAP API           |     SOAP 1.1                         |
| WSDL version                |     2020.2.0                         |

## Feature Overview
- A single client is used across all network operations which supports the netsuite token based authentication mechanism.
- The NetSuite module has modelled the existing standard NetSuite entities/records in to Ballerina record types with
 widely used set of fields.

## Getting Started

### Prerequisites
Download and install [Ballerina](https://ballerinalang.org/downloads/).

### Supported Operations
* Get
* GetAll
* GetList
* GetSavedSearch
* SearchCustomer
* SearchTransaction

### Pull the Module
Execute the below command to pull the NetSuite module from Ballerina Central:
```ballerina
$ ballerina pull ballerinax/netsuite
```
## Sample

Instantiate the connector by giving authentication details in the HTTP client config, which has built-in support for 
TBA . NetSuite uses TBA to authenticate and authorize requests. The NetSuite connector can be instantiated 
in the HTTP client config using the access token or using the client ID, client secret, access token and access token secret.

**Obtaining Tokens**

1. Visit [NetSuite](https://www.netsuite.com) and create an Account.
2. Enable the SuiteTalk Webservice features of the account (Setup->Company->Enable Features).
3. Obtain the SuiteTalk Base URL, which contains the account ID under the company URLs (Setup->Company->Company
 Information).
    E.g., https://<ACCOUNT_ID>.suitetalk.api.netsuite.com
4. Create an integration application (Setup->Integration->New), enable TBA code grant and scope, and obtain the 
following credentials: 
    * Client ID
    * Client Secret
5. Obtain the below credentials by following the token based authorization in the [NetSuite documentation](https://system.na0.netsuite.com/app/help/helpcenter.nl?fid=book_1559132836.html&vid=_BLm3ruuApc_9HXr&chrole=17&ck=9Ie2K7uuApI_9PHO&cktime=175797&promocode=&promocodeaction=overwrite&sj=7bfNB5rzdVQdIKGhDJFE6knJf%3B1590725099%3B165665000). 
    * Access Token
    * Access Token Secret

**Create the NetSuite client**

```ballerina
// Create a NetSuite client configuration by reading from the config file.
// Import the connector
import ballerinax.module_ballerinax_netsuite as netsuite;
netsuite:NetsuiteConfiguration config = {
    accountId: <accountId>,
    consumerId: <consumerId>,
    consmerSecret: <consmerSecret>,
    token: <token>,
    tokenSecret: <tokenSecret>,
    baseURL: <baseURL>
};

netsuite:Client nsClient = new(nsConfig);
```

**Perform NetSuite operations**

The following sample shows how NetSuite `Currency` entity on GetAll operation.

```ballerina
import ballerina/io;
import ballerinax.module_ballerinax_netsuite as netsuite;

public function main() {
    json|error output = nsClient->getAll("currency");
    if (output is json) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
        test:assertFalse(false, output.message());
    }
}
```
