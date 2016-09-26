//load l'api youtube de google
var tag = document.createElement('script');

tag.src = "https://apis.google.com/js/client.js?onload=onClientLoad";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

function onClientLoad() {
    gapi.client.load('youtube', 'v3', onYouTubeApiLoad);
}

var apiKey = 'AIzaSyDwcgZT5go3hKZ-azZ0WkOCFEzeKx6cWLA';

function onYouTubeApiLoad() {
    gapi.client.setApiKey(apiKey);
    //effectue la recherche sur le string
    search($(".string-playlist").html());
}

//load l'api iframe de youtube
var tag2 = document.createElement('script');

tag2.src = "https://www.youtube.com/iframe_api";
var firstScriptTag2 = document.getElementsByTagName('script')[0];
firstScriptTag2.parentNode.insertBefore(tag2, firstScriptTag2);

var videoId = "";

//fn qui fait la recherche
function search(query) {
    var request = gapi.client.youtube.search.list({
        part: 'snippet',
        type: 'video',
        q: query,
        maxResults: 1

    });
    request.execute(function(response) {
        if (typeof response.items[0] != "undefined" && response.items[0] != null) {
            videoId = response.items[0].id.videoId;
            $(".yt-video-title").html(response.items[0].snippet.title);
        } else {
            //aucune video trouvee
            videoId = "QMlSsz6BDVQ";
            $(".yt-video-title").html("404 not found");
        }
        //creer l'iframe avec la video
        onYouTubeIframeAPIReady2(videoId);
    });
}

var player;
var playerLoaded = 0;

function onYouTubeIframeAPIReady2(videoId2) {
    $(".yt-video-id").html(videoId);
    player = new YT.Player('player', {
        videoId: videoId2,
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange // celui la est dans la view pour les variables du framework
        }
    });
    playerLoaded = 1;

    // responsive
    fluidvids.init({
        selector: ['iframe', 'object'], // runs querySelectorAll()
        players: ['www.youtube.com', 'player.vimeo.com'] // players to support
    });
    fluidvids.render();
}

function onPlayerReady(event) {
    event.target.playVideo();
}

function stopVideo() {
    player.stopVideo();
}

//reload la page si l'iframe a essaye de se load avant que l'api ai charge
setTimeout(function() {
    if (playerLoaded == 0) {
        location.reload();
    }
}, 2000);