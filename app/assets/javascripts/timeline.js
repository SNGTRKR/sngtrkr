var page, old_width, new_width
function timeline_scroll() {
  $(document).ready(function () {
    // Scroll to end of timeline
    // Set global AJAX load variable
    var last_load = new Date().getTime();;
    
    page = 2
    // Ajax scroll load
    
    $(document).scroll(function () {
      if ($(this).scrollTop() > ($(this).height() - 1500) && (new Date().getTime() - last_load) > 1000) {
        last_load = new Date().getTime();;
        $(this).trigger('mouseup');
        console.log("Mouseup");
        $.get('/users/me/timeline/' + page);
        page++;
      }
    });
  });
}

function timeline_widths() {
  // Width setting
  var stepsWidth = 0;
  $('.release-list .release-outer').each(function (i) {
    var $step = $(this);
    stepsWidth += $step.width() - 75;
  });
  return stepsWidth + 50
}

function timeline_setup() {
  var each_release;
  $(".r-grad, .release-info").mouseover(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').stop().animate({
      bottom: 25
    });
  }).mouseout(function () {
    each_release.find('.release-info').stop().animate({
      bottom: 0
    });
  });
    $(".share-release").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeOut("normal");
    each_release.find('.opac-50').fadeIn("normal");
    each_release.find('.share-release-list').animate({
      right: 0
    }, "slow");
  });
  $(".share-cancel").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeIn("normal");
    each_release.find('.opac-50').fadeOut("normal");
    each_release.find('.share-release-list').animate({
      right: -310
    }, "slow");
  });
  $(".release-outer .each-release .share-release-list ul a li").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeIn("normal");
    each_release.find('.opac-50').fadeOut("normal");
    each_release.find('.share-release-list').animate({
      right: -310
    }, "slow");
  });
  $(".buy-release").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeOut("normal");
    each_release.find('.opac-50').fadeIn("normal");
    each_release.find('.buy-release-list').animate({
      left: 0
    }, "slow");
  });
  $(".buy-cancel").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeIn("normal");
    each_release.find('.opac-50').fadeOut("normal");
    each_release.find('.buy-release-list').animate({
      left: -310
    }, "slow");
  });
  $(".release-outer .each-release .buy-release-list ul li").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeIn("normal");
    each_release.find('.opac-50').fadeOut("normal");
    each_release.find('.buy-release-list').animate({
      left: -310
    }, "slow");
  });
  
  $(".play-release").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeOut("normal");
    each_release.find('.opac-50').fadeIn("normal");
    each_release.find('.play-release-list').animate({
      top: 0
    }, "slow");
  });
  $(".play-release-list .icon-remove").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeIn("normal");
    each_release.find('.opac-50').fadeOut("normal");
    each_release.find('.play-release-list').animate({
      top : -310
    }, "slow");
  });
  $(".release-outer .each-release .play-release-list ul a li").click(function () {
    each_release = $(this).closest('.each-release');
    each_release.find('.release-info').animate({
      bottom: 0
    }, "slow");
    each_release.find('.r-grad').fadeIn("normal");
    each_release.find('.opac-50').fadeOut("normal");
    each_release.find('.play-release-list').animate({
      top: -310
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