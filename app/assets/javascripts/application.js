// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery_ujs
//= require jquery-ui
//= require fancy-box/jquery.fancybox
//= require instant-search/instant-search
//= require jplayer/jquery.jplayer
//= require jplayer/jquery.jplayer.inspector
//= require jplayer/jplayer.playlist
$(document).ready(function() {
	$("#delete-account a").fancybox({
		width : 431,
		height : 286,
		autoSize	: false,
		closeClick	: false
	});
	$(".delete-artist-pad a").fancybox({
		width : 431,
		height : 286,
		autoSize	: false,
		closeClick	: false
	});
	$(".release-menu a").fancybox({
		width : 543,
		height : 315,
		autoSize	: false
	});
	$("#artist-info a").fancybox({
		autoScale	: true,
	});
	$("#manage-top a").fancybox({
		autoScale	: true,
	});
  /*$('#artist-mini-search-submit').click(function(){
    $(this).closest('form').submit();
    return false;
  });*/
  $('#mini_search_field').keyup(function(){ $.get("/artists.json", { search: $('#mini_search_field').val() }, 
    function(data){
      $.each(data, function(){ 
      $('#mini_search_results').html("<li><a href=\"/artist/"+this.id+"\">"+this.name+"<br /><span>"+this.genre+"</span></a></li>");
      });
    })}
  );
});

    	

