public type SearchElement record {
    string fieldName;
    string operator;
    SearchType searchType;
    string value1;
    string value2?;
};

public enum SearchType {
   SEARCH_STRING_FIELD = "SearchStringField",
   SEARCH_BOOLEAN_FIELD = "SearchBooleanField",
   SEARCH_DOUBLE_FIELD = "SearchDoubleField",
   SEARCH_LONG_FIELD = "SearchLongField",
   SEARCH_TEXT_NUMBER_FIELD = "SearchTextNumberField",
   SEARCH_DATE_FIELD = "SearchDateField" 
}

function getSearchElement(SearchElement[] searchElements) returns string{
    string searchElementInPayloadBody = "";
    foreach SearchElement element in searchElements {
        searchElementInPayloadBody += string `<ns1:${element.fieldName} 
        operator="${element.operator}" 
        xsi:type="urn1:${element.searchType.toString()}">
        <urn1:searchValue>${element.value1}</urn1:searchValue>
        ${getOptionalSearchValue(element).toString()}
        </ns1:${element.fieldName}>`; 
    }
    return searchElementInPayloadBody;
}

function getOptionalSearchValue(SearchElement searchElement) returns string?{
    if(searchElement?.value2 is string) {
        return string `<urn1:searchValue2>${searchElement?.value2.toString()}</urn1:searchValue2>`;
    } else {
        return;
    }
}


// function getSearchElementType() returns string {
//     //match and return field type;
//     match searchElement.searchType {
//         SEARCH_STRING_FIELD => {
            
//         }
//         SEARCH_BOOLEAN_FIELD => {

//         }
//         SEARCH_DOUBLE_FIELD => {

//         }
//         SEARCH_LONG_FIELD => {

//         }
//         SEARCH_TEXT_NUMBER_FIELD => {

//         }
//         SEARCH_DATE_FIELD => {

//         }
//     }
// }

