function applyLoadingMaskToSubmit(){
    form = document.getElementById('encodedItemForm');
    form.addEventListener('submit', function(event) {
        showLoadingMaskDialog();
    });
}

function showLoadingMaskAndRedirectToList(){
    window.location='/encoded_items';
    showLoadingMaskDialog();
}

applyLoadingMaskToSubmit();