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
	$ ->
	  $("#slider").slider
	    min: 0
	    max: 250
	    step: 50
	    #slide: (event, ui) ->
	    #  $("#amount").val "$" + ui.value

	#  $("#amount").val "$" + $("#slider").slider("value")
	$(".share_artist").popover
	  html: true
	  content: ->
	    $(".art_pop").html()
	$(".share_release").popover
	  html: true
	  content: ->
	    $(".rel_pop").html()
	$(".share, .buy").click ->
      $(this).toggleClass "active"
    $(".buy").popover
      html: true
      content: ->
      	$(".buy_pop").html()







