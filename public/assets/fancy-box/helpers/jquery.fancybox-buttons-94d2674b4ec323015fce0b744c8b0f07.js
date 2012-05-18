/*!
 * Buttons helper for fancyBox
 * version: 1.0.2
 * @requires fancyBox v2.0 or later
 *
 * Usage: 
 *     $(".fancybox").fancybox({
 *         buttons: {
 *             position : 'top'
 *         }
 *     });
 * 
 * Options:
 *     tpl - HTML template
 *     position - 'top' or 'bottom'
 * 
 */
(function(a){var b=a.fancybox;b.helpers.buttons={tpl:'<div id="fancybox-buttons"><ul><li><a class="btnPrev" title="Previous" href="javascript:;"></a></li><li><a class="btnPlay" title="Start slideshow" href="javascript:;"></a></li><li><a class="btnNext" title="Next" href="javascript:;"></a></li><li><a class="btnToggle" title="Toggle size" href="javascript:;"></a></li><li><a class="btnClose" title="Close" href="javascript:jQuery.fancybox.close();"></a></li></ul></div>',list:null,buttons:{},update:function(){var a=this.buttons.toggle.removeClass("btnDisabled btnToggleOn");b.current.canShrink?a.addClass("btnToggleOn"):b.current.canExpand||a.addClass("btnDisabled")},beforeLoad:function(a){if(b.group.length<2){b.coming.helpers.buttons=!1,b.coming.closeBtn=!0;return}b.coming.margin[a.position==="bottom"?2:0]+=30},onPlayStart:function(){this.list&&this.buttons.play.attr("title","Pause slideshow").addClass("btnPlayOn")},onPlayEnd:function(){this.list&&this.buttons.play.attr("title","Start slideshow").removeClass("btnPlayOn")},afterShow:function(c){var d;this.list||(this.list=a(c.tpl||this.tpl).addClass(c.position||"top").appendTo("body"),this.buttons={prev:this.list.find(".btnPrev").click(b.prev),next:this.list.find(".btnNext").click(b.next),play:this.list.find(".btnPlay").click(b.play),toggle:this.list.find(".btnToggle").click(b.toggle)}),d=this.buttons,b.current.index>0||b.current.loop?d.prev.removeClass("btnDisabled"):d.prev.addClass("btnDisabled"),b.current.loop||b.current.index<b.group.length-1?(d.next.removeClass("btnDisabled"),d.play.removeClass("btnDisabled")):(d.next.addClass("btnDisabled"),d.play.addClass("btnDisabled")),this.update()},onUpdate:function(){this.update()},beforeClose:function(){this.list&&this.list.remove(),this.list=null,this.buttons={}}}})(jQuery);