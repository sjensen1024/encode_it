function showMainSecretEntryDialog() {
    document.getElementById("mainSecretEntryDialog").showModal();
};

function hideMainSecretEntryDialog() {
    document.getElementById("mainSecretEntryDialog").close();
}

function showAccessDeniedDialog() {
    document.getElementById("accessDeniedDialog").showModal();
}

function hideAccessDeniedDialog() {
    document.getElementById("accessDeniedDialog").close();
}

function showLoadingMaskDialog(){
    document.getElementById("loadingMaskDialog").showModal();
}

function hideLoadingMaskDialog(){
    document.getElementById("loadingMaskDialog").close();
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

function processMainSecretEntrySubmission() {
    showLoadingMaskDialog();

    let requestObject = new XMLHttpRequest();
    let url = '/decoded_items?main_secret_entry=' + getMainSecretEntry();
    requestObject.open("GET", url, true);

    requestObject.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            clearMainSecretEntry();
            parsedResponse = JSON.parse(this.responseText);

            if (!parsedResponse.allowed) {
                hideLoadingMaskDialog();
                showAccessDeniedDialog();
                return;
            }

            for (let i = 0; i < parsedResponse.decoded_items.length; i++) {
                decodedItem = parsedResponse.decoded_items[i];
                element = document.getElementById('decoded_item_' + decodedItem.id);
                element.innerHTML = decodedItem.value;
                element.className = "revealed_encoded_value";
                if (i == parsedResponse.decoded_items.length - 1){
                    hideLoadingMaskDialog();
                    document.getElementById("showDecodedValuesButton").disabled = true;
                }
            }
        }
    }
    requestObject.send();
    hideMainSecretEntryDialog();
}

function deleteEncodedItem(encodedItemId){
    if (!confirm("Are you sure you want to delete this item? This cannot be undone.")) {
        return;
    }

    showLoadingMaskDialog();
    authenticityToken = document.getElementById('formAuthenticityToken').value;

    let requestObject = new XMLHttpRequest();
    let url = '/encoded_items/' + encodedItemId + '?authenticity_token=' + authenticityToken;
    requestObject.open("DELETE", url, true);

    requestObject.onreadystatechange = function () {
        if (this.readyState != 4) {
            return;
        }
        if (this.status != 200){
            hideLoadingMaskDialog();
            alert("There was an error in deleting this item.");
            return;
        }

        location.reload();
    }
    requestObject.send();
}
