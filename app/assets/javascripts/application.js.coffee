#= require jquery_ujs
$(document).ready ->

	#secondary nav drop down animation
	$('#show_info a').click ->
		if $("#more_info").is(":hidden")
		  $("#more_info").slideDown "slow"
		  $('.navbar').animate
		  	top:120,
		  	"slow"
		  $("#show_info a").text "Close"
		else
		  $("#more_info").slideUp "slow"
		  $('.navbar').animate
		  	top:0,
		  	"slow"
		  $("#show_info a").text "Info"	  

	#tooltip initiation	  
	$('.tip').tooltip()

	#profile settings slider
	current_frequency = $('#slider').data "current"
	$ ->
	  $("#slider").slider
	    min: 1
	    max: 5
	    step: 1
	    value: current_frequency
	    animate: 'true'	
	    slide: (event, ui) ->
	     $("#user_email_frequency").val ui.value

	  $("#user_email_frequency").val $("#slider").slider("value")

	#popovers for buy and share
	$(".share, .buy").click ->
      $(this).toggleClass "active"

    $("body").on "click", ".popover a", ->
    	$(".share, .buy").each ->
	    	$(this).popover "hide"
		    $(this).removeClass "active"


	$("body").on "click", (e) ->
	  $(".share, .buy").each ->
	    if not ($(this).is(e.target) or $(this).has(e.target).length > 0) and $(this).siblings(".popover").length isnt 0 and $(this).siblings(".popover").has(e.target).length is 0
	      $(this).popover "hide"
	      $(this).removeClass "active"

	$('.image').click ->
		$('.front').toggleClass('front-flip')
		$('.back').toggleClass('back-flip')

	$(".share_artist").each ->
	  $elem = $(this)
	  art_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".art_pop_"+ art_id + "").html()

	$(".share_release").each ->
	  $elem = $(this)
	  rel_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".rel_pop_"+ rel_id + "").html()

	$(".buy").each ->
	  $elem = $(this)
	  buy_id = $elem.attr("id")
	  $elem.popover
	    html: true
	    content: $(".buy_pop_"+ buy_id + "").html()

	#handling multiple modals, closing others when a modal is triggered
	$('.signup').click ->
		$('#user_login').modal "hide"
		$('#forgot_password').modal "hide"
		$('.signup').children().addClass "active"

	$('.login').click ->
		$('#user_signup').modal "hide"
		$('#forgot_password').modal "hide"
		$(this).parent().addClass "active"

	$('#user_login').on "hidden", ->
		$('.login').parent().removeClass "active"

	$('#user_signup').on "hidden", ->
		$('.signup').children().removeClass "active"

	$('#user_login a').click ->
		$('#user_login').modal "hide"

	$('#forgot_password a').click ->
		$('#forgot_password').modal "hide"
		$('.login').parent().addClass "active"

	#alert animation
	$(".alert").removeClass("fadeOutUp").show().addClass "fadeInDown"
	window.setTimeout (->
	  $(".alert").removeClass("fadeInDown").addClass("fadeOutUp").one "webkitAnimationEnd animationend", ->
	  	$(this).remove();
	), 4000

	#allow anchor links for nav tabs
	url = document.location.toString()
	$(".nav-tabs a[href=#" + url.split("#")[1] + "]").tab "show"  if url.match("#")

	#homepage release animation
	$container = $("#releases")
	$releases = $container.children("a")
	timeout = undefined
	$releases.on "mouseenter", (event) ->
	  $article = $(this)
	  clearTimeout timeout
	  timeout = setTimeout(->
	    return false  if $article.hasClass("active")
	    $releases.not($article).removeClass("active").addClass "blur"
	    $article.removeClass("blur").addClass "active"
	  , 75)

	$container.on "mouseleave", (event) ->
	  clearTimeout timeout
	  $releases.removeClass "active blur"


	#enable client side validation within modals  
	$('.modal').on 'shown', ->
	  $(this).find('input:visible:first').focus().end().find('form').enableClientSideValidations()

	#scrollable left sidebar
	$(window).load ->
	  scroll_height = $('.scrollable_inner').outerHeight() #grab height of inner scrollbar div
	  $('.scrollable_inner').css 'height', scroll_height #assign height to inner scrollbar div
	  window_height = $(window).height() #grab current window height
	  $('.scrollable').css 'height', window_height #set parent scrollbar div as window height
	  full_scroll_height = scroll_height + 81 #add page navbar and padding when calculating scroll start point in comparison to window height
	  #check and add scrollbar if required on page load
	  if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	  else 
	  	 $('.scrollable_inner').css 'height', scroll_height #if window height is not less than scrollbar inner div height, assign its original height

	  #check and add scrollbar if required on window resizing in real time
	  $(window).resize -> 
	   window_height = $(window).height()
	   $('.scrollable').css 'height', window_height
	   if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	   else 
	  	 $('.scrollable_inner').css 'height', scroll_height

	#remove trkr ajax normal
	follow_buttons = ->
		$("a.remove-trkr").bind "ajax:complete", ->
		  artist_id = $(this).data("id")
		  $(this).replaceWith "<a href=\"/artists/" + artist_id + "/follows\" class=\"add-trkr btn track\" data-id=\"" + artist_id + "\" data-method=\"post\" data-remote=\"true\" format=\"html\" rel=\"nofollow\">Track</a>"
		  follow_buttons()
		  $('#row-'+ artist_id).addClass("fadeOutUp").slideUp()
		#add trkr ajax normal
		$("a.add-trkr").bind "ajax:complete", ->
		  artist_id = $(this).data("id")
		  $(this).replaceWith "<a href=\"/artists/" + artist_id + "/unfollow\" class=\"remove-trkr btn track active\" data-id=\"" + artist_id + "\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\">Tracked</a>"
		  follow_buttons()
		  FB.api "/me/sngtrkr:track", "post",
		    artist: "http://sngtrkr.com/artists/" + $(this).data("id")
		  , (response) ->
		    console.log "FB Open Graph Posted"
		    console.log response

	follow_buttons()
	#remove trkr ajax small
	follow_buttons_small = ->
		$("a.remove-trkr-small").bind "ajax:complete", ->
		  artist_id = $(this).data("id")
		  $(this).replaceWith "<a href=\"/artists/" + artist_id + "/follows\" class=\"add-trkr-small btn btn-small\" data-id=\"" + artist_id + "\" data-method=\"post\" data-remote=\"true\" format=\"html\" rel=\"nofollow\">Track</a>"
		  $('.trackers')
		  follow_buttons_small()
		#add trkr ajax small
		$("a.add-trkr-small").bind "ajax:complete", ->
		  artist_id = $(this).data("id")
		  $(this).replaceWith "<a href=\"/artists/" + artist_id + "/unfollow\" class=\"remove-trkr-small btn btn-small active\" data-id=\"" + artist_id + "\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\">Tracked</a>"
		  follow_buttons_small()
		  FB.api "/me/sngtrkr:track", "post",
		    artist: "http://sngtrkr.com/artists/" + $(this).data("id")
		  , (response) ->
		    console.log "FB Open Graph Posted"
		    console.log response

	follow_buttons_small()
	#search query
	query = $('#tab3').data 'query'
	rel_last_load = new Date().getTime()
	rel_page = 2
	#release infinite scrolling
	$("#tab3").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - rel_last_load) > 1000
		      rel_last_load = new Date().getTime()
		      console.log "AJAX release page load: " + rel_page
		      url = "/search?utf8=✓&query=" + query + "&r_page=" + rel_page
		      console.log url
		      $.get url
		      rel_page++

	art_last_load = new Date().getTime()
	art_page = 2
#artist infinite scrolling   
	$("#tab2").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - art_last_load) > 1000
		      art_last_load = new Date().getTime()
		      console.log "AJAX artist page load: " + art_page
		      url = "/search?utf8=✓&query=" + query + "&a_page=" + art_page
		      console.log url
		      $.get url
		      art_page++

    user_id = $('#tab1').data 'user'
	trk_last_load = new Date().getTime()
	trk_page = 2
#artist_tracked list infinite scrolling   
	$("#tab1").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - trk_last_load) > 1000
		      trk_last_load = new Date().getTime()
		      console.log "AJAX artist_tracked page load: " + trk_page
		      url = "/users/" + user_id + "?page=" + trk_page
		      console.log url
		      $.get url
		      trk_page++


	






