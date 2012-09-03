//= require jquery_ujs
//= require instant-search/instant-search
//= require jplayer/jquery.jplayer
//= require jplayer/jplayer.playlist
//= require carousel/jquery.carousel-packed.js
//= require best_in_place
//= require rotate/jQueryRotate.2.2
//
// BOOTSTRAP REQUIRES
//
//= require scrollbar/jquery.mousewheel.js
//
// MATT'S REQUIRES
//
//= require follow-unfollow
//= require suggestions
//= require facebook

String.prototype.commafy = function () {
  return this.replace(/(^|[^\w.])(\d{4,})/g, function ($0, $1, $2) {
    return $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,");
  });
};

Number.prototype.commafy = function () {
  return String(this).commafy();
};

$(document).ready(function () { 

  // Best in place
  if($('.best_in_place').length > 0){
    $(".best_in_place").best_in_place();
    $.datepicker.setDefaults($.datepicker.regional["gb"]);
  };

  // Flash Dismissal
  if($('.flash-outer').length > 0){
    $('.flash-outer').slideDown(500, 'easeInQuad');
    $('.flash-close').click(function () {
      $('.flash-outer').slideUp(500, 'easeInQuad');
    })
    if ($('.flash-outer').data('disappear-after')) {
      console.log("delay detected");
      $('.flash-outer').delay($('.flash-outer').data('disappear-after')).slideUp(1000, 'easeInQuad');
    }
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
  
});