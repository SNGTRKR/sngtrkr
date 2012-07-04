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
//= require jplayer/jplayer.playlist
//= require carousel/jquery.carousel-packed.js
//= require jquery.purr
//= require best_in_place
//= require rotate/jQueryRotate.2.2
//= require jquery.scrollto-1.4.2-min
function artist_suggestion_replace(){
	$('.add-trkr, a.ignore-trk-artist').bind('ajax:complete', function() {
		// Hide the suggestion itself
		console.log("Successfully Trked Artist")
		$(this).closest('li').fadeOut(300);
	});
  $('a.untrk-artist').bind('ajax:complete', function() {
		console.log("Successfully Untrked Artist")
		$(this).closest('li').fadeOut(300);
		$('#user-following-count').html(parseInt($('#user-following-count').html(),10) - 1);
	});
	// Disables buttons by hiding them after they are clicked.
	$('.add-trkr, a.untrk-artist, a.ignore-trk-artist').click(function(){$(this).hide()});

}

String.prototype.commafy = function () {
	return this.replace(/(^|[^\w.])(\d{4,})/g, function($0, $1, $2) {
		return $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,");
	});
}

Number.prototype.commafy = function () {
	return String(this).commafy();
}


$(document).ready(function() {

  // Flash Dismissal
  $('.flash-outer').delay(300).slideDown(500,'easeInQuad');
  $('#flash-dismiss').click(function(){
    $('.flash-outer').slideUp(500,'easeInQuad');
  })
  if($('.flash-outer').data('disappear-after')){
    console.log("delay detected");
    $('.flash-outer').delay($('.flash-outer').data('disappear-after')).slideUp(1000,'easeInQuad');
  }

  // Release rating.
  $('a').live('ajax:complete', function(xhr, status) {
    $(".ajaxful-rating-wrapper").replaceWith(status.responseText)
  });
  
	$("#delete-account a").fancybox({
		width : 431,
		height : 286,
		autoSize	: false,
		closeClick	: false
	});
	$("#delete-artist-trigger a").fancybox({
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
	$("#artist-bio a").fancybox({
		autoScale	: true,
	});
	$("#manage-top a").fancybox({
		autoScale	: true,
	});
  /*$('#artist-mini-search-submit').click(function(){
    $(this).closest('form').submit();
    return false;
  });*/
  $('#mini_search_field').keyup(function(){ $.get("/artists/search.json", { search: $('#mini_search_field').val() }, 
    function(data){
      if(data == null){
        $('#mini_search_results').html("<a>Sorry, we found no results...</a>")
      } else {
        $('#mini_search_results').html("")
        $.each(data, function(){ 
          $('#mini_search_results').append("<li><a href=\"/artists/"+this.id+"\">"+this.name+"<br /><span>"+this.genre+"</span></a></li>");
        });
      }
    })}
  );
});

    	

