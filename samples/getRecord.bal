import ballerinax/netsuite as netsuite;
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

    //Parameter request record
    netsuite:GetReqestFeild request = {
        internalId: "539839",
        recordType: "invoice"
    };
    //Get operation for retriving a record from netsuite
    netsuite:GetResponse|error output = netsuiteClient->get(request);
    if (output is netsuite:GetResponse) {
        netsuite:Invoice? invoice = output?.invoice;
        if (invoice is netsuite:Invoice) {
            string statusValue = invoice?.status.toString();
            log:print("The status : " + statusValue);
        } else {
            log:printError("No invoice found");
        }
    } else {
        log:printError(output.toString());
    }
}
