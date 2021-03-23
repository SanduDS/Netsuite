import sandudslk/netsuite as netsuite;
import ballerina/log;

public function main() {
    //Preparing the netsuite configuration with TBA authentication tokens.
    netsuite:NetsuiteConfiguration config = {
        accountId: "",
        consumerId: "",
        consmerSecret: "",
        token: "",
        tokenSecret: "",
        baseURL: ""
    };

    //Creates a netsuite client for soap requests
    netsuite:Client netsuiteClient = checkpanic new (config);

    //Creates request records
    log:print("testGetList");
    netsuite:GetListReqestFeild requestList = {
        internalId:  "86912", 
        recordType: "invoice"
    };
    netsuite:GetListReqestFeild requestList1 = {
        internalId:  "1020", 
        recordType: "customer"
    };
    netsuite:GetListReqestFeild[] arrylist = [requestList,requestList1];
    //Gets the list of results for the given records types and internal ids.
    netsuite:GetListResponse|error output = netsuiteClient->getList(arrylist);
    if (output is netsuite:GetListResponse) {
        log:print(output.toString());
    } else {
        log:printError(output.toString());
    }
}
