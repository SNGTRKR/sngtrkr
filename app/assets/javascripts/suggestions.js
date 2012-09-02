// Replace a suggestion in the sidebar with a new one
function sidebar_new_suggestion(data){
  return "<li class=\"each-recommend\"> <img alt=\"Suggestion\" src=\""+data.image_url+"\"> <div class=\"info\"> <div class=\"a-name\"> <strong><a href=\"/artists/"+data.artist.id+"\">"+data.artist.name+"</a></strong> </div> <span>"+data.followers+" TRKRS</span><br> <div class=\"buttons\"><a href=\"/artists/"+data.artist.id+"/follows.json\" class=\"sidebar-add-trkr\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\">Track</a> <!-- - Share -->- <a href=\"/artists/"+data.artist.id+"/unsuggest.json\" class=\"sidebar-ignore-trkr\" data-remote=\"true\">Ignore</a></div> </div> </li>";
};
