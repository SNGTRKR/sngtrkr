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

	$(".share_sngtrkr").popover
		html: true
		content: $(".sngtrkr_pop").html();

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
	  $single_release = $(this)
	  clearTimeout timeout
	  timeout = setTimeout(->
	    return false  if $single_release.hasClass("active")
	    $releases.not($single_release).removeClass("active").addClass "blur"
	    $single_release.removeClass("blur").addClass "active"
	  , 75)

	$container.on "mouseleave", (event) ->
	  clearTimeout timeout
	  $releases.removeClass "active blur"

	hide_sidebar = ->
	  if $(window).width() < 1200
	    $(".g_right_sidebar").hide()
	  else
	    $(".g_right_sidebar").show()
	hide_sidebar()


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
	  # Positioning the typeahead results
	  typepos = $('.search-query').offset()
	  $('.search-data-query').css "left", typepos["left"]
	  # Add the new attribute to the style tag, while retaining the current style attributes. Used to ensure !important rule is activated
	  $(".tt-dropdown-menu").attr "style", (i, s) ->
		  s + "left: " + typepos['left'] + "px !important;"


	  #check and add scrollbar if required on window resizing in real time
	  $(window).resize -> 
	   hide_sidebar()
	   window_height = $(window).height()
	   $('.scrollable').css 'height', window_height
	   if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	   else 
	  	 $('.scrollable_inner').css 'height', scroll_height


	#search query
	query = $('#tab3').data 'query'
	rel_last_load = new Date().getTime()
	rel_page = 2
	#release infinite scrolling
	$(".search-tab-content #tab3").bind "mousewheel", (event, delta) ->
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
	$(".search-tab-content #tab2").bind "mousewheel", (event, delta) ->
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
	$(".profile-tab-content #tab1").bind "mousewheel", (event, delta) ->
      if delta < 0
	      if $(document).scrollTop() > ($(document).height() - 1500) and (new Date().getTime() - trk_last_load) > 1000
		      trk_last_load = new Date().getTime()
		      console.log "AJAX artist_tracked page load: " + trk_page
		      url = "/users/" + user_id + "?page=" + trk_page
		      console.log url
		      $.get url
		      trk_page++

	$(".search-query").typeahead(
	  remote: "/search.json?utf8=✓&query=%QUERY"
	  prefetch: "/search.json"
	  template: "<div class='inner-suggest'><img src='{{image.image.url}}'/><span><div>{{value}}</div>{{label}}{{artist_name}}</span><div class='{{identifier}}'></div></div>"
	  engine: Hogan
	  limit: 6
	).on "typeahead:selected", ($e, data) ->
	  $typeahead = $(@)
	  $form = $typeahead.parents('form').first()
	  $form.submit()
	  if data.identifier is "release"
	  	window.location = "/artists/" + data.artist_id + "/releases/" + data.id
	  else if data.itentifier is "artist"
	  	window.location = "/artists/" + data.id

 	dataquery = $('.search-data-query')

	$('.search-query').bind "input", ->
		if $('.search-query').val() is ""
			dataquery.hide()
		else
	    	s_query = $('.search-query').val()
	    	dataquery.show().html "<a href ='/search?utf8=✓&query=" + s_query + "'><div>Search for '<span>" + s_query + "</span>'</div></a>"

    $('.search-query').blur ->
    	setTimeout (->
    		dataquery.hide()
    	), 150

    $('.search-query').focus ->
    	unless $('.search-query').val() is ""
    		dataquery.show()

    dataquery.hover ->
    	$('.tt-suggestion').removeClass 'tt-is-under-cursor'


	






