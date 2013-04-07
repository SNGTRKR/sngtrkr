//= require jquery_ujs

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
	





