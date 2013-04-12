#= require jquery_ujs
$(document).ready ->
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
	$('.tip').tooltip()
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

	$(".alert").removeClass("fadeOutUp").show().addClass "fadeInDown"

	window.setTimeout (->
	  $(".alert").removeClass("fadeInDown").addClass("fadeOutUp").one "webkitAnimationEnd animationend", ->
	  	$(this).remove();
	), 4000

	url = document.location.toString()
	$(".nav-tabs a[href=#" + url.split("#")[1] + "]").tab "show"  if url.match("#")
	
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

	$('.modal').on 'shown', ->
	  $(this).find('input:visible:first').focus().end().find('form').enableClientSideValidations()
	#scrollable left sidebar
	$(window).load ->
	  scroll_height = $('.scrollable_inner').outerHeight()
	  $('.scrollable_inner').css 'height', scroll_height
	  window_height = $(window).height()
	  $('.scrollable').css 'height', window_height
	  full_scroll_height = scroll_height + 81 #add page navbar and padding when calculating scroll start point in comparison to window height
	  add_scrollbar = undefined
	  doneResizing = ->
	    $('.scrollable_inner').after '<div class="scrollbar"></div>'
	  #check and add scrollbar if required on page load
	  if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	  	 unless $('.scrollbar').length
	  	  clearTimeout(add_scrollbar)
	  	  add_scrollbar = setTimeout(doneResizing, 500)
	  else 
	  	 $('.scrollable_inner').css 'height', scroll_height
	  	 $('.scrollbar').remove
	  #check and add scrollbar if required on window resizing in real time
	  $(window).resize ->
	   window_height = $(window).height()
	   $('.scrollable').css 'height', window_height
	   if window_height < full_scroll_height
	  	 $('.scrollable_inner').css 'height', window_height - 81 #then calculating the height of the scrollable content, subtract the page navbar and padding
	  	 unless $('.scrollbar').length
	  	  clearTimeout(add_scrollbar)
	  	  add_scrollbar = setTimeout(doneResizing, 500)
	   else 
	  	 $('.scrollable_inner').css 'height', scroll_height
	  	 $('.scrollbar').remove

	

	






