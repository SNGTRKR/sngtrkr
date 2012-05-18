/*!
 * Thumbnail helper for fancyBox
 * version: 1.0.4
 * @requires fancyBox v2.0 or later
 *
 * Usage:
 *     $(".fancybox").fancybox({
 *         thumbs: {
 *             width  : 50,
 *             height : 50
 *         }
 *     });
 *
 * Options:
 *     width - thumbnail width
 *     height - thumbnail height
 *     source - function to obtain the URL of the thumbnail image
 *     position - 'top' or 'bottom'
 *
 */
(function(a){var b=a.fancybox;b.helpers.thumbs={wrap:null,list:null,width:0,source:function(b){var c;return a.type(b)==="string"?b:(c=a(b).find("img"),c.length?c.attr("src"):b.href)},init:function(c){var d=this,e,f=c.width||50,g=c.height||50,h=c.source||this.source;e="";for(var i=0;i<b.group.length;i++)e+='<li><a style="width:'+f+"px;height:"+g+'px;" href="javascript:jQuery.fancybox.jumpto('+i+');"></a></li>';this.wrap=a('<div id="fancybox-thumbs"></div>').addClass(c.position||"bottom").appendTo("body"),this.list=a("<ul>"+e+"</ul>").appendTo(this.wrap),a.each(b.group,function(c){a("<img />").load(function(){var b=this.width,e=this.height,h,i,j;if(!d.list||!b||!e)return;h=b/f,i=e/g,j=d.list.children().eq(c).find("a"),h>=1&&i>=1&&(h>i?(b=Math.floor(b/i),e=g):(b=f,e=Math.floor(e/h))),a(this).css({width:b,height:e,top:Math.floor(g/2-e/2),left:Math.floor(f/2-b/2)}),j.width(f).height(g),a(this).hide().appendTo(j).fadeIn(300)}).attr("src",h(b.group[c]))}),this.width=this.list.children().eq(0).outerWidth(!0),this.list.width(this.width*(b.group.length+1)).css("left",Math.floor(a(window).width()*.5-(b.current.index*this.width+this.width*.5)))},update:function(c){this.list&&this.list.stop(!0).animate({left:Math.floor(a(window).width()*.5-(b.current.index*this.width+this.width*.5))},150)},beforeLoad:function(a){if(b.group.length<2){b.coming.helpers.thumbs=!1;return}b.coming.margin[a.position==="top"?0:2]=a.height+30},afterShow:function(a){this.list?this.update(a):this.init(a),this.list.children().removeClass("active").eq(b.current.index).addClass("active")},onUpdate:function(){this.update()},beforeClose:function(){this.wrap&&this.wrap.remove(),this.wrap=null,this.list=null,this.width=0}}})(jQuery);