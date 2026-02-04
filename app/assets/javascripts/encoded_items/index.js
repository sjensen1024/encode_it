function showMainSecretEntryDialog() {
    document.getElementById("mainSecretEntryDialog").showModal();
};

function showAddNewMainEncodedItemDialog(){
    document.getElementById("addNewMainEncodedItemDialog").showModal();
}

function showAddNewEncodedItemDialog() {
    document.getElementById("addNewEncodedItemDialog").showModal();
};

function prepareForAddingNewMainEncodedItem(){
    preText = document.getElementById("newEncodedItemPreText");
    preText.innerHTML = "<p>Enter a main secret here.</p> <p>It will be used for decoding.</p>";
    descriptorInput = document.getElementById("addNewEncodedItemDescriptor");
    descriptorInput.value = "MAIN ENCODED ITEM";
    descriptorInput.readOnly = true;
}

function prepareForAddingRegularEncodedItem(){
    preText = document.getElementById("newEncodedItemPreText");
    preText.innerHTML = "<p>Enter a new item to encode.</p>";
    descriptorInput = document.getElementById("addNewEncodedItemDescriptor");
    descriptorInput.value = "";
    descriptorInput.readOnly = false;
}   

function hideMainSecretEntryDialog() {
    document.getElementById("mainSecretEntryDialog").close();
}

function showAccessDeniedDialog() {
    document.getElementById("accessDeniedDialog").showModal();
}

function hideAccessDeniedDialog() {
    document.getElementById("accessDeniedDialog").close();
}

function hideDeleteItemDialog() {
    document.getElementById("deleteItemDialog").close();
}

function showExportEncodedItemsDialog() {
    document.getElementById("exportEncodedItemsDialog").showModal();
}

function hideExportEncodedItemsDialog() {
    document.getElementById("exportEncodedItemsDialog").close();
}

function hideAddNewMainEncodedItemDialog(){
    document.getElementById("addNewMainEncodedItemDialog").close();
}

function hideAddNewEncodedItemDialog() {
    document.getElementById("addNewEncodedItemDialog").close();
};

function showDeleteItemDialogWithItemId(itemId){
    yesButton = document.getElementById("deleteItemDialogYesButton");
    yesButton.setAttribute('willDeleteItemId', itemId);
    document.getElementById("deleteItemDialog").showModal();
}

function deleteItemFromButtonClick(){
    hideDeleteItemDialog();
    yesButton = document.getElementById("deleteItemDialogYesButton");
    deleteEncodedItem(yesButton.getAttribute('willDeleteItemId'));
}

function reopenSecretEntryFromAccessDenied() {
    hideAccessDeniedDialog();
    showMainSecretEntryDialog();
}

function getMainSecretEntry(){
    return document.getElementById("mainSecretEntryText").value;
}

function processAddNewEncodedItem() {
    hideAddNewEncodedItemDialog();
}

function processAddNewMainEncodedItem() {
    hideAddNewMainEncodedItemDialog();
    addNewEncodedItemButton = document.getElementById("addNewEncodedItemButton");
    addNewEncodedItemButton.disabled = true;
    exportEncodedItemsButton = document.getElementById("exportEncodedItemsButton");
    exportEncodedItemsButton.disabled = true;
    toggleTableBlur();
}

function processMainSecretEntrySubmission() {
    let requestObject = new XMLHttpRequest();
    let url = '/decoded_items?main_secret_entry=' + getMainSecretEntry();
    requestObject.open("GET", url, true);

    requestObject.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            parsedResponse = JSON.parse(this.responseText);
            if (!parsedResponse.allowed) {
                showAccessDeniedDialog();
                return;
            }

            addNewEncodedItemButton = document.getElementById("addNewEncodedItemButton");
            addNewEncodedItemButton.disabled = false;
            exportEncodedItemsButton = document.getElementById("exportEncodedItemsButton");
            exportEncodedItemsButton.disabled = false;

            toggleTableBlur();
        }
    }
    requestObject.send();
    hideMainSecretEntryDialog();
}

function toggleEncodedItemValueDisplay(encodedItemId){
    element =  document.getElementById('decoded_item_' + encodedItemId);
    if (element.className === "hidden_encoded_value"){
        showDecodedItemValue(encodedItemId);
    } else {
        element.innerHTML = "?";
        element.className = "hidden_encoded_value";
    }
}

function showDecodedItemValue(encodedItemId){
    let requestObject = new XMLHttpRequest();

    authenticityToken = document.getElementById('formAuthenticityToken').value;
    let url = '/decoded_items/' + encodedItemId + '?authenticity_token=' + authenticityToken + '&main_secret_entry=' + getMainSecretEntry();
    requestObject.open("GET", url, true);

    requestObject.onreadystatechange = function () {
        if (this.readyState != 4 || this.status != 200) {
            return;
        }

        parsedResponse = JSON.parse(this.responseText);
        element =  document.getElementById('decoded_item_' + encodedItemId);
        if (!parsedResponse.allowed){
            alert("Access Denied: Incorrect main secret entry.");
            return;
        }
        
        element.innerHTML = parsedResponse.decoded_item.value;
        element.className = "revealed_encoded_value";
    }
    requestObject.send();
}


function deleteEncodedItem(encodedItemId){
    authenticityToken = document.getElementById('formAuthenticityToken').value;

    let requestObject = new XMLHttpRequest();
    let url = '/encoded_items/' + encodedItemId + '?authenticity_token=' + authenticityToken + '&main_secret_entry=' + getMainSecretEntry();
    requestObject.open("DELETE", url, true);
    requestObject.setRequestHeader('Accept', 'text/vnd.turbo-stream.html');

    requestObject.onreadystatechange = function () {
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200){
            alert("There was an error in deleting this item.");
            return;
        }

        Turbo.renderStreamMessage(this.responseText);
    }
    requestObject.send();
}

function exportEncodedItemsBackupFile(){
    authenticityToken = document.getElementById('formAuthenticityToken').value;
    let requestObject = new XMLHttpRequest();
    let url = '/file_backup/export?authenticity_token=' + authenticityToken;
    requestObject.open("POST", url, true);
    requestObject.send();

    requestObject.onreadystatechange = function () {
        if (this.readyState != 4 && this.responseText !== '') {
            showExportEncodedItemsDialog();
            return;
        }
        if (this.status != 200){
            alert("There was an error in exporting the backup file.");
            return;
        }
    }   
}

function toggleTableBlur() {
    const container = document.getElementById('encoded_item');
    if (!container) return;
    const isBlurred = container.classList.toggle('blurred');
}

document.addEventListener('DOMContentLoaded', function() {
    let requestObject = new XMLHttpRequest();
    let url = '/main_encoded_item_existence.json'
    requestObject.open("GET", url, true);

     requestObject.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            parsedResponse = JSON.parse(this.responseText);
            if (!parsedResponse.does_main_encoded_item_exist){
                showAddNewMainEncodedItemDialog();
                return;
            }
            addNewEncodedItemButton = document.getElementById("addNewEncodedItemButton");
            addNewEncodedItemButton.disabled = true;
            exportEncodedItemsButton = document.getElementById("exportEncodedItemsButton");
            exportEncodedItemsButton.disabled = true;
            //toggleTableBlur();
            showMainSecretEntryDialog();
        }
    }
    requestObject.send();
});
