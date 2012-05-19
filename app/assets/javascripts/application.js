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
//= require jquery.min
//= require jquery_ujs
$(document).ready(function() {
	$("#delete-account a").fancybox({
		width : 431,
		height : 286,
		autoSize	: false,
		closeClick	: false
	});
    		$(".manage-artist").click(function(){
  			 $(".step-back").animate({height:134},"slow");
  			 $(".step").animate({height:222},"slow");	
  			 $("#progress").animate({width:65},"slow");
  			 $('.percent').html('25%');	 
  			 $('.white-tint').hide();
  			 $('.white-tint-2').show();
  			 $('.white-tint-3').show();
  			 $('.white-tint-4').show();
});
$(".manage-details").click(function(){
  			 $(".step-back").animate({height:421},"slow");
  			 $(".step").animate({height:505},"slow");
  			 $("#progress").animate({width:130},"slow");
  			 $('.percent').html('50%');
  			 $('.white-tint-2').hide();
  			 $('.white-tint').show();
  			 $('.white-tint-3').show();
  			 $('.white-tint-4').show();
});
$(".manage-picture").click(function(){
  			 $(".step-back").animate({height:187},"slow");
  			 $(".step").animate({height:275},"slow");
  			 $("#progress").animate({width:195},"slow");
  			 $('.percent').html('75%');
  			 $('.white-tint-3').hide();
  			 $('.white-tint-2').show();
  			 $('.white-tint').show();
  			 $('.white-tint-4').show();
});
$(".manage-summary").click(function(){
  			 $(".step-back").animate({height:283},"slow");
  			 $(".step").animate({height:371},"slow");
  			 $("#progress").animate({width:265},"slow");
  			 $('.percent').html('100%');
  			 $('.white-tint-4').hide();
  			 $('.white-tint-2').show();
  			 $('.white-tint-3').show();
  			 $('.white-tint').show();
});
    	});
    	

