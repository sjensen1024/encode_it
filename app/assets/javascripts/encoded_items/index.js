function showMainSecretEntryDialog() {
    document.getElementById("mainSecretEntryDialog").showModal();
};

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

function clearMainSecretEntry(){
    document.getElementById("mainSecretEntryText").value = "";
}

function processAddNewEncodedItem() {
    hideAddNewEncodedItemDialog();
}


function processMainSecretEntrySubmission() {
    let requestObject = new XMLHttpRequest();
    let url = '/decoded_items?main_secret_entry=' + getMainSecretEntry();
    requestObject.open("GET", url, true);

    requestObject.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            clearMainSecretEntry();
            parsedResponse = JSON.parse(this.responseText);

            if (!parsedResponse.allowed) {
                showAccessDeniedDialog();
                return;
            }

            for (let i = 0; i < parsedResponse.decoded_items.length; i++) {
                decodedItem = parsedResponse.decoded_items[i];
                element = document.getElementById('decoded_item_' + decodedItem.id);
                element.innerHTML = decodedItem.value;
                element.className = "revealed_encoded_value";
                if (i == parsedResponse.decoded_items.length - 1)
                    document.getElementById("showDecodedValuesButton").disabled = true;
            }

            toggleTableBlur();
        }
    }
    requestObject.send();
    hideMainSecretEntryDialog();
}

function deleteEncodedItem(encodedItemId){
    authenticityToken = document.getElementById('formAuthenticityToken').value;

    let requestObject = new XMLHttpRequest();
    let url = '/encoded_items/' + encodedItemId + '?authenticity_token=' + authenticityToken;
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

/* Toggle table blur (toggles .blurred on #encoded_item and updates the button ARIA/text) */
function toggleTableBlur() {
    const container = document.getElementById('encoded_item');
    const btn = document.getElementById('toggleBlurButton');
    if (!container || !btn) return;
    const isBlurred = container.classList.toggle('blurred');
    btn.setAttribute('aria-pressed', isBlurred ? 'true' : 'false');
    btn.textContent = isBlurred ? 'Unblur Table' : 'Blur Table';
}

document.addEventListener('DOMContentLoaded', function() {
    let requestObject = new XMLHttpRequest();
    let url = '/main_encoded_item_existence.json'
    requestObject.open("GET", url, true);

     requestObject.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            parsedResponse = JSON.parse(this.responseText);
            if (!parsedResponse.does_main_encoded_item_exist){
                prepareForAddingNewMainEncodedItem();
                showAddNewEncodedItemDialog();
                return;
            }
            prepareForAddingRegularEncodedItem();
            toggleTableBlur();
            showMainSecretEntryDialog();
        }
    }
    requestObject.send();
});
