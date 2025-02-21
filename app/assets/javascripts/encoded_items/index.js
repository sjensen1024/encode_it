function showMainSecretEntryDialog() {
    document.getElementById('mainSecretEntryDialog').showModal();
};

function hideMainSecretEntryDialog() {
    document.getElementById('mainSecretEntryDialog').close();
}

function processMainSecretEntrySubmission() {
    entryBoxValue = document.getElementById('mainSecretEntryText').value;

    let requestObject = new XMLHttpRequest();
    let url = '/decoded_items?main_secret_entry=' + entryBoxValue;
    requestObject.open("GET", url, true);
    requestObject.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            parsedResponse = JSON.parse(this.responseText);

            if (!parsedResponse.allowed) {
                alert('You did not enter the correct value for the main secret. Decoding failed.');
                return;
            }

            for (let i = 0; i < parsedResponse.decoded_items.length; i++) {
                decodedItem = parsedResponse.decoded_items[i];
                element = document.getElementById('decoded_item_' + decodedItem.id);
                element.innerHTML = decodedItem.value;
            }
        }
    }
    requestObject.send();
    hideMainSecretEntryDialog();
}
