$(document).ready ->
	$('.team_member').hoverIntent (->
		$(this).find('span').animate
			height:238,
			backgroundColor:'#000000',
			"slow"
		$(this).find('.social').stop().delay(750).fadeTo "slow", 1
		$(this).find('.title').animate
			top:19,
			"slow"
	), ->
		$(this).find('span').animate
			height:50,
			"slow"
		$(this).find(".social").stop().fadeTo "normal", 0
		$(this).find('.title').animate
			top:0,
			"slow"