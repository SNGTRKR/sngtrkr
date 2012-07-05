//= require jquery.scrollto-1.4.2-min

$(document).ready(function () {
  // Scroll to end of timeline
  $("#timeline").scrollTo('max');
  // Set global AJAX load variable
  var last_load = new Date().getTime();;
  $('.release-list').width(timeline_widths());
  var page = 2
  // Ajax scroll load
  $('#timeline').scroll(function () {
    if ($(this).scrollLeft() < 500 && (new Date().getTime() - last_load) > 300) {
      last_load = new Date().getTime();;
      $(this).trigger('mouseup');
      console.log('Scrolled to end!');
      $.get('/users/me/timeline/' + page);
      page++;
    }
  });
  timeline_setup();
});

function timeline_widths() {
  // Width setting
  var stepsWidth = 0;
  $('.release-list .release-outer').each(function (i) {
    var $step = $(this);
    stepsWidth += $step.width();
  });
  return stepsWidth
}

function timeline_setup() {
    $(".share-release").click(function () {
    $(this).closest(".each-release").find('.release-info').animate({
      bottom: -100
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').animate({
      bottom: -25
    }, "slow");
    $(this).closest(".each-release").find('.r-grad').fadeOut("normal");
    $(this).closest(".each-release").find('.opac-50').fadeIn("normal");
    $(this).closest(".each-release").find('#share-release').animate({
      right: 0
    }, "slow");
  });
  $(".r-grad").mouseover(function () {
    $(this).closest(".each-release").find('.release-info').stop().animate({
      bottom: 33
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').stop().animate({
      bottom: 0
    }, "slow");
  }).mouseout(function () {
    $(this).closest(".each-release").find('.release-info').stop().animate({
      bottom: 13
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').stop().animate({
      bottom: -25
    }, "slow");
  });
  $(".share-cancel").click(function () {
    $(this).closest(".each-release").find('.release-info').animate({
      bottom: 13
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').animate({
      bottom: -25
    }, "slow");
    $(this).closest(".each-release").find('.r-grad').fadeIn("normal");
    $(this).closest(".each-release").find('.opac-50').fadeOut("normal");
    $(this).closest(".each-release").find('#share-release').animate({
      right: -210
    }, "slow");
  });
  $(".sm-trigger").click(function () {
    $(this).closest(".each-release").find('.release-info').animate({
      bottom: 13
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').animate({
      bottom: -25
    }, "slow");
    $(this).closest(".each-release").find('.r-grad').fadeIn("normal");
    $(this).closest(".each-release").find('.opac-50').fadeOut("normal");
    $(this).closest(".each-release").find('#share-release').animate({
      right: -210
    }, "slow");
  });
  $(".buy-release").click(function () {
    $(this).closest(".each-release").find('.release-info').animate({
      bottom: -100
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').animate({
      bottom: -25
    }, "slow");
    $(this).closest(".each-release").find('.r-grad').fadeOut("normal");
    $(this).closest(".each-release").find('.opac-50').fadeIn("normal");
    $(this).closest(".each-release").find('#buy-release').animate({
      left: 0
    }, "slow");
  });
  $(".buy-cancel").click(function () {
    $(this).closest(".each-release").find('.release-info').animate({
      bottom: 13
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').animate({
      bottom: -25
    }, "slow");
    $(this).closest(".each-release").find('.r-grad').fadeIn("normal");
    $(this).closest(".each-release").find('.opac-50').fadeOut("normal");
    $(this).closest(".each-release").find('#buy-release').animate({
      left: -210
    }, "slow");
  });
  $(".buy-trigger").click(function () {
    $(this).closest(".each-release").find('.release-info').animate({
      bottom: 13
    }, "slow");
    $(this).closest(".each-release").find('.release-menu').animate({
      bottom: -25
    }, "slow");
    $(this).closest(".each-release").find('.r-grad').fadeIn("normal");
    $(this).closest(".each-release").find('.opac-50').fadeOut("normal");
    $(this).closest(".each-release").find('#buy-release').animate({
      left: -210
    }, "slow");
  });

  $('#timeline').mousedown(function (event) {
    $(this).data('down', true).data('x', event.clientX).data('scrollLeft', this.scrollLeft);
    return false;
  }).mouseup(function (event) {
    $(this).data('down', false);
  }).mousemove(function (event) {
    if ($(this).data('down') == true) {
      this.scrollLeft = $(this).data('scrollLeft') + $(this).data('x') - event.clientX;
    }
  }).mousewheel(function (event, delta) {
    this.scrollLeft -= (delta * 30);
  }).css({
    'overflow': 'hidden',
    'cursor': '-moz-grab'
  });

  $(window).mouseout(function (event) {
    if ($('#timeline').data('down')) {
      try {
        if (event.originalTarget.nodeName == 'BODY' || event.originalTarget.nodeName == 'HTML') {
          $('#timeline').data('down', false);
        }
      } catch (e) {}
    }
  });
}