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
//= require instant-search/instant-search
//= require jplayer/jquery.jplayer
//= require jplayer/jplayer.playlist
//= require carousel/jquery.carousel-packed.js
//= require best_in_place
//= require rotate/jQueryRotate.2.2
// BOOTSTRAP REQUIRES
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-tab
String.prototype.commafy = function () {
  return this.replace(/(^|[^\w.])(\d{4,})/g, function ($0, $1, $2) {
    return $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,");
  });
}

Number.prototype.commafy = function () {
  return String(this).commafy();
}

$(document).ready(function () {
  // Flash Dismissal
  $('.flash-outer').delay(300).slideDown(500, 'easeInQuad');
  $('.flash-close').click(function () {
    $('.flash-outer').slideUp(500, 'easeInQuad');
  })
  if ($('.flash-outer').data('disappear-after')) {
    console.log("delay detected");
    $('.flash-outer').delay($('.flash-outer').data('disappear-after')).slideUp(1000, 'easeInQuad');
  }

  // Release rating.
  $('a').live('ajax:complete', function (xhr, status) {
    $(".ajaxful-rating-wrapper").replaceWith(status.responseText);
  });
  $('#artist-mini-search-submit').click(function(){
    $(this).closest('form').submit();
    return false;
  });
  $('#mini_search_field').typeahead({
      source: function(typeahead, query) {
          $.ajax({
              url: "/artists/search.json",
              dataType: "json",
              type: "POST",
              data: {
                  query: query
              },
              success: function(data) {
                  var return_list = [], i = data.length;
                  while (i--) {
                      return_list[i] = {id: data[i].id, value: data[i].name};
                  }
                  typeahead.process(return_list);
              }
          });
      },
      onselect: function(obj) {
          window.location = "/artists/"+ obj.id;
      }
  });
  
  $('.popover-parent').popover();
  $('.tooltip-parent').tooltip();
  $(".alert").alert();
  add_remove_trkr_bind();
  
}); // DOCUMENT READY ENDS HERE

function add_remove_trkr_bind() {

  $('a.remove-trkr').bind('ajax:complete', function () {
    console.log('Added tracker');
    var artist_id = $(this).data('id');
    $(this).replaceWith('<a href="/artists/'+artist_id+'/follows" class="mini-trkr-button add-trkr" data-id="'+artist_id+'" data-method="post" data-remote="true" rel="nofollow"><i class="icon-plus"></i></a>');
    add_remove_trkr_bind();
  });
  $('a.add-trkr').bind('ajax:complete', function () {
    console.log('Removed tracker');
    var artist_id = $(this).data('id');
    $(this).replaceWith('<a href="/artists/'+artist_id+'/unfollow" class="mini-trkr-button  remove-trkr" data-id="'+artist_id+'" data-method="post" data-remote="true" rel="nofollow"><i class="icon-minus"></i></a>');
    add_remove_trkr_bind();
  });

}

function artist_suggestion_replace() {
  // Sharing options
	$(".mini-share").click(function() {
		$(this).parent().parent().find('.opac-50').fadeIn("normal").parent().find('.share-artist').animate({right : 0}, "slow").parent().find('.recommend-info').fadeOut("normal");
	});
	$(".share-cancel").click(function() {
		$(this).parent().parent().find('.opac-50').fadeOut("normal").parent().find('.share-artist').animate({right : -202}, "slow").parent().find('.recommend-info').fadeIn("normal");;
	});
	$(".share-artist ul a li").click(function() {
		$(this).parent().parent().parent().parent().find('.opac-50').fadeOut("normal").parent().find('.share-artist').animate({right : -202}, "slow").parent().find('.recommend-info').fadeIn("normal");;
	});

  $('.recommend-buttons a.add-trkr').bind('ajax:success', function(xhr, data, status){
    FB.api("/me/sngtrkr:track", 'post', {artist: $(this).closest('li').data("id")});
  });

  $('.recommend-buttons a.add-trkr, .recommend-buttons a.ajax-ignore-artist').bind('ajax:beforeSend', function () {
    // Hide the suggestion itself
    $(this).closest('li').css("opacity",0.3);
  }).bind('ajax:success', function(xhr, data, status){
    $(this).closest('li').replaceWith(data); 
    // Reactivate click functionality for new suggestion
    artist_suggestion_replace();
  });

  $('a.untrk-artist').bind('ajax:beforeSend', function () {
    $(this).closest('li').fadeOut(300);
    $('#user-following-count').html(parseInt($('#user-following-count').html(), 10) - 1);
  });
  // Disables buttons after they are clicked.
  $('a').bind('ajax:beforeSend', function(){$(this).removeAttr('href');});
  
}