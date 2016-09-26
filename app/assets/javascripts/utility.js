// load une url en js (pour contourner le probleme des load api)
function loadUrl(newLocation) {
    window.location.href = newLocation;
    return false;
}
