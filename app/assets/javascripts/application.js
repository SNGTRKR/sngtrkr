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
//= require bootstrap-transition
//= require scrollbar/jquery.jscrollpane.min.js
//= require scrollbar/jquery.mousewheel.js
//= require scrollbar/scroll-startstop.events.jquery.js
String.prototype.commafy = function () {
  return this.replace(/(^|[^\w.])(\d{4,})/g, function ($0, $1, $2) {
    return $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,");
  });
}

Number.prototype.commafy = function () {
  return String(this).commafy();
}
function sectionsize() {
		actrecheight = $("#recommendations").height();
		actsideheight = $("#sidebar").height();
		actheight = actsideheight - actrecheight;
		$("#activity-stream ul").css("height", actheight );
}

$(document).ready(function () { 
//sidebar sectioning 
sectionsize();
$(window).resize(function(){
					        sectionsize();
					    });
	//loading 
	var angle = 0;
setInterval(function(){
      angle+=3;
     $("#loading-icon").rotate(angle);
},25);
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
  
  // Bootstrap global classes.
  $('.popover-parent').popover();
  $('.tooltip-parent').tooltip();
  $(".alert").alert();

  add_remove_trkr_bind();
  //scrollbar hover
	$(function() {
			
				// the element we want to apply the jScrollPane
				var $el					= $('#activity-stream ul').jScrollPane({
					verticalGutter 	: -16
				}),
						
				// the extension functions and options 	
					extensionPlugin 	= {
						
						extPluginOpts	: {
							// speed for the fadeOut animation
							mouseLeaveFadeSpeed	: 500,
							// scrollbar fades out after hovertimeout_t milliseconds
							hovertimeout_t		: 1000,
							// if set to false, the scrollbar will be shown on mouseenter and hidden on mouseleave
							// if set to true, the same will happen, but the scrollbar will be also hidden on mouseenter after "hovertimeout_t" ms
							// also, it will be shown when we start to scroll and hidden when stopping
							useTimeout			: true,
							// the extension only applies for devices with width > deviceWidth
							deviceWidth			: 980
						},
						hovertimeout	: null, // timeout to hide the scrollbar
						isScrollbarHover: false,// true if the mouse is over the scrollbar
						elementtimeout	: null,	// avoids showing the scrollbar when moving from inside the element to outside, passing over the scrollbar
						isScrolling		: false,// true if scrolling
						addHoverFunc	: function() {
							
							// run only if the window has a width bigger than deviceWidth
							if( $(window).width() <= this.extPluginOpts.deviceWidth ) return false;
							
							var instance		= this;
							
							// functions to show / hide the scrollbar
							$.fn.jspmouseenter 	= $.fn.show;
							$.fn.jspmouseleave 	= $.fn.fadeOut;
							
							// hide the jScrollPane vertical bar
							var $vBar			= this.getContentPane().siblings('.jspVerticalBar').hide();
							
							/*
							 * mouseenter / mouseleave events on the main element
							 * also scrollstart / scrollstop - @James Padolsey : http://james.padolsey.com/javascript/special-scroll-events-for-jquery/
							 */
							$el.bind('mouseenter.jsp',function() {
								
								// show the scrollbar
								$vBar.stop( true, true ).jspmouseenter();
								
								if( !instance.extPluginOpts.useTimeout ) return false;
								
								// hide the scrollbar after hovertimeout_t ms
								clearTimeout( instance.hovertimeout );
								instance.hovertimeout 	= setTimeout(function() {
									// if scrolling at the moment don't hide it
									if( !instance.isScrolling )
										$vBar.stop( true, true ).jspmouseleave( instance.extPluginOpts.mouseLeaveFadeSpeed || 0 );
								}, instance.extPluginOpts.hovertimeout_t );
								
								
							}).bind('mouseleave.jsp',function() {
								
								// hide the scrollbar
								if( !instance.extPluginOpts.useTimeout )
									$vBar.stop( true, true ).jspmouseleave( instance.extPluginOpts.mouseLeaveFadeSpeed || 0 );
								else {
								clearTimeout( instance.elementtimeout );
								if( !instance.isScrolling )
										$vBar.stop( true, true ).jspmouseleave( instance.extPluginOpts.mouseLeaveFadeSpeed || 0 );
								}
								
							});
							
							if( this.extPluginOpts.useTimeout ) {
								
								$el.bind('scrollstart.jsp', function() {
								
									// when scrolling show the scrollbar
								clearTimeout( instance.hovertimeout );
								instance.isScrolling	= true;
								$vBar.stop( true, true ).jspmouseenter();
								
							}).bind('scrollstop.jsp', function() {
								
									// when stop scrolling hide the scrollbar (if not hovering it at the moment)
								clearTimeout( instance.hovertimeout );
								instance.isScrolling	= false;
								instance.hovertimeout 	= setTimeout(function() {
									if( !instance.isScrollbarHover )
											$vBar.stop( true, true ).jspmouseleave( instance.extPluginOpts.mouseLeaveFadeSpeed || 0 );
									}, instance.extPluginOpts.hovertimeout_t );
								
							});
							
								// wrap the scrollbar
								// we need this to be able to add the mouseenter / mouseleave events to the scrollbar
							var $vBarWrapper	= $('<div/>').css({
								position	: 'absolute',
								left		: $vBar.css('left'),
								top			: $vBar.css('top'),
								right		: $vBar.css('right'),
								bottom		: $vBar.css('bottom'),
								width		: $vBar.width(),
								height		: $vBar.height()
							}).bind('mouseenter.jsp',function() {
								
								clearTimeout( instance.hovertimeout );
								clearTimeout( instance.elementtimeout );
								
								instance.isScrollbarHover	= true;
								
									// show the scrollbar after 100 ms.
									// avoids showing the scrollbar when moving from inside the element to outside, passing over the scrollbar								
								instance.elementtimeout	= setTimeout(function() {
									$vBar.stop( true, true ).jspmouseenter();
								}, 100 );	
								
							}).bind('mouseleave.jsp',function() {
								
									// hide the scrollbar after hovertimeout_t
								clearTimeout( instance.hovertimeout );
								instance.isScrollbarHover	= false;
								instance.hovertimeout = setTimeout(function() {
										// if scrolling at the moment don't hide it
									if( !instance.isScrolling )
											$vBar.stop( true, true ).jspmouseleave( instance.extPluginOpts.mouseLeaveFadeSpeed || 0 );
									}, instance.extPluginOpts.hovertimeout_t );
								
							});
							
							$vBar.wrap( $vBarWrapper );
							
						}
						
						}
						
					},
					
					// the jScrollPane instance
					jspapi 			= $el.data('jsp');
					
				// extend the jScollPane by merging	
				$.extend( true, jspapi, extensionPlugin );
				jspapi.addHoverFunc();
			
			});
  
}); // DOCUMENT READY ENDS HERE

// Set up add / remove buttons to replace with remove / add buttons on click
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

// All javascript needed for artist suggestion ajax replacement and general behaviour
function artist_suggestion_replace() {
  // Sharing options
	$(".mini-share").click(function() {
    var parent = $(this).parent().parent()
		parent.find('.opac-50').fadeIn("normal");
    parent.find('.share-artist').animate({right : 0}, "slow");
    parent.find('.recommend-info').fadeOut("normal");
	});
	$(".share-cancel").click(function() {
    var parent = $(this).parent().parent();
		parent.find('.opac-50').fadeOut("normal");
    parent.find('.share-artist').animate({right : -202}, "slow");
    parent.find('.recommend-info').fadeIn("normal");
	});
	$(".share-artist ul a li").click(function() {
    var parent = $(this).parent().parent().parent().parent();
		parent.find('.opac-50').fadeOut("normal");
    parent.find('.share-artist').animate({right : -202}, "slow");
    parent.find('.recommend-info').fadeIn("normal");
	});

  $('.recommend-buttons a.add-trkr').bind('ajax:success', function(xhr, data, status){
    $('#user-following-count').html(parseInt($('#user-following-count').html(), 10) + 1);
    $('.tracked-artists').append("");
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