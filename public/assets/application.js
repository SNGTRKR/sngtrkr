(function(a,b){var c;a.rails=c={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not(button[type])",disableSelector:"input[data-disable-with], button[data-disable-with], textarea[data-disable-with]",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input:file",linkDisableSelector:"a[data-disable-with]",CSRFProtection:function(b){var c=a('meta[name="csrf-token"]').attr("content");c&&b.setRequestHeader("X-CSRF-Token",c)},fire:function(b,c,d){var e=a.Event(c);return b.trigger(e,d),e.result!==!1},confirm:function(a){return confirm(a)},ajax:function(b){return a.ajax(b)},href:function(a){return a.attr("href")},handleRemote:function(d){var e,f,g,h,i,j;if(c.fire(d,"ajax:before")){h=d.data("cross-domain")||null,i=d.data("type")||a.ajaxSettings&&a.ajaxSettings.dataType;if(d.is("form")){e=d.attr("method"),f=d.attr("action"),g=d.serializeArray();var k=d.data("ujs:submit-button");k&&(g.push(k),d.data("ujs:submit-button",null))}else d.is(c.inputChangeSelector)?(e=d.data("method"),f=d.data("url"),g=d.serialize(),d.data("params")&&(g=g+"&"+d.data("params"))):(e=d.data("method"),f=c.href(d),g=d.data("params")||null);return j={type:e||"GET",data:g,dataType:i,crossDomain:h,beforeSend:function(a,e){return e.dataType===b&&a.setRequestHeader("accept","*/*;q=0.5, "+e.accepts.script),c.fire(d,"ajax:beforeSend",[a,e])},success:function(a,b,c){d.trigger("ajax:success",[a,b,c])},complete:function(a,b){d.trigger("ajax:complete",[a,b])},error:function(a,b,c){d.trigger("ajax:error",[a,b,c])}},f&&(j.url=f),c.ajax(j)}return!1},handleMethod:function(d){var e=c.href(d),f=d.data("method"),g=d.attr("target"),h=a("meta[name=csrf-token]").attr("content"),i=a("meta[name=csrf-param]").attr("content"),j=a('<form method="post" action="'+e+'"></form>'),k='<input name="_method" value="'+f+'" type="hidden" />';i!==b&&h!==b&&(k+='<input name="'+i+'" value="'+h+'" type="hidden" />'),g&&j.attr("target",g),j.hide().append(k).appendTo("body"),j.submit()},disableFormElements:function(b){b.find(c.disableSelector).each(function(){var b=a(this),c=b.is("button")?"html":"val";b.data("ujs:enable-with",b[c]()),b[c](b.data("disable-with")),b.prop("disabled",!0)})},enableFormElements:function(b){b.find(c.enableSelector).each(function(){var b=a(this),c=b.is("button")?"html":"val";b.data("ujs:enable-with")&&b[c](b.data("ujs:enable-with")),b.prop("disabled",!1)})},allowAction:function(a){var b=a.data("confirm"),d=!1,e;return b?(c.fire(a,"confirm")&&(d=c.confirm(b),e=c.fire(a,"confirm:complete",[d])),d&&e):!0},blankInputs:function(b,c,d){var e=a(),f,g=c||"input,textarea";return b.find(g).each(function(){f=a(this);if(d?f.val():!f.val())e=e.add(f)}),e.length?e:!1},nonBlankInputs:function(a,b){return c.blankInputs(a,b,!0)},stopEverything:function(b){return a(b.target).trigger("ujs:everythingStopped"),b.stopImmediatePropagation(),!1},callFormSubmitBindings:function(c,d){var e=c.data("events"),f=!0;return e!==b&&e.submit!==b&&a.each(e.submit,function(a,b){if(typeof b.handler=="function")return f=b.handler(d)}),f},disableElement:function(a){a.data("ujs:enable-with",a.html()),a.html(a.data("disable-with")),a.bind("click.railsDisable",function(a){return c.stopEverything(a)})},enableElement:function(a){a.data("ujs:enable-with")!==b&&(a.html(a.data("ujs:enable-with")),a.data("ujs:enable-with",!1)),a.unbind("click.railsDisable")}},a.ajaxPrefilter(function(a,b,d){a.crossDomain||c.CSRFProtection(d)}),a(document).delegate(c.linkDisableSelector,"ajax:complete",function(){c.enableElement(a(this))}),a(document).delegate(c.linkClickSelector,"click.rails",function(d){var e=a(this),f=e.data("method"),g=e.data("params");if(!c.allowAction(e))return c.stopEverything(d);e.is(c.linkDisableSelector)&&c.disableElement(e);if(e.data("remote")!==b)return(d.metaKey||d.ctrlKey)&&(!f||f==="GET")&&!g?!0:(c.handleRemote(e)===!1&&c.enableElement(e),!1);if(e.data("method"))return c.handleMethod(e),!1}),a(document).delegate(c.inputChangeSelector,"change.rails",function(b){var d=a(this);return c.allowAction(d)?(c.handleRemote(d),!1):c.stopEverything(b)}),a(document).delegate(c.formSubmitSelector,"submit.rails",function(d){var e=a(this),f=e.data("remote")!==b,g=c.blankInputs(e,c.requiredInputSelector),h=c.nonBlankInputs(e,c.fileInputSelector);if(!c.allowAction(e))return c.stopEverything(d);if(g&&e.attr("novalidate")==b&&c.fire(e,"ajax:aborted:required",[g]))return c.stopEverything(d);if(f)return h?c.fire(e,"ajax:aborted:file",[h]):!a.support.submitBubbles&&a().jquery<"1.7"&&c.callFormSubmitBindings(e,d)===!1?c.stopEverything(d):(c.handleRemote(e),!1);setTimeout(function(){c.disableFormElements(e)},13)}),a(document).delegate(c.formInputClickSelector,"click.rails",function(b){var d=a(this);if(!c.allowAction(d))return c.stopEverything(b);var e=d.attr("name"),f=e?{name:e,value:d.val()}:null;d.closest("form").data("ujs:submit-button",f)}),a(document).delegate(c.formSubmitSelector,"ajax:beforeSend.rails",function(b){this==b.target&&c.disableFormElements(a(this))}),a(document).delegate(c.formSubmitSelector,"ajax:complete.rails",function(b){this==b.target&&c.enableFormElements(a(this))})})(jQuery),function(a,b,c,d){"use strict";var e=c(a),f=c(b),g=c.fancybox=function(){g.open.apply(this,arguments)},h=!1,i=null,j=b.createTouch!==d,k=function(a){return c.type(a)==="string"},l=function(a){return k(a)&&a.indexOf("%")>0},m=function(a,b){return b&&l(a)&&(a=g.getViewport()[b]/100*parseInt(a,10)),Math.round(a)+"px"};c.extend(g,{version:"2.0.5",defaults:{padding:0,margin:20,width:800,height:600,minWidth:100,minHeight:100,maxWidth:9999,maxHeight:9999,autoSize:!0,autoResize:!j,autoCenter:!j,fitToView:!0,aspectRatio:!1,topRatio:.5,fixed:!1,scrolling:"no",wrapCSS:"",arrows:!0,closeBtn:!0,closeClick:!1,nextClick:!1,mouseWheel:!0,autoPlay:!1,playSpeed:3e3,preload:3,modal:!1,loop:!0,ajax:{dataType:"html",headers:{"X-fancyBox":!0}},keys:{next:[13,32,34,39,40],prev:[8,33,37,38],close:[27]},index:0,type:null,href:null,content:null,title:null,tpl:{wrap:'<div class="fancybox-wrap"><div class="fancybox-skin"><div class="fancybox-outer"><div class="fancybox-inner"></div></div></div></div>',image:'<img class="fancybox-image" src="{href}" alt="" />',iframe:'<iframe class="fancybox-iframe" name="fancybox-frame{rnd}" frameborder="0" hspace="0"'+(c.browser.msie?' allowtransparency="true"':"")+"></iframe>",swf:'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%"><param name="wmode" value="transparent" /><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="{href}" /><embed src="{href}" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="100%" height="100%" wmode="transparent"></embed></object>',error:'<p class="fancybox-error">The requested content cannot be loaded.<br/>Please try again later.</p>',closeBtn:'<div title="Close" class="fancybox-item fancybox-close"></div>',next:'<a title="Next" class="fancybox-nav fancybox-next"><span></span></a>',prev:'<a title="Previous" class="fancybox-nav fancybox-prev"><span></span></a>'},openEffect:"fade",openSpeed:300,openEasing:"swing",openOpacity:!0,openMethod:"zoomIn",closeEffect:"fade",closeSpeed:300,closeEasing:"swing",closeOpacity:!0,closeMethod:"zoomOut",nextEffect:"elastic",nextSpeed:300,nextEasing:"swing",nextMethod:"changeIn",prevEffect:"elastic",prevSpeed:300,prevEasing:"swing",prevMethod:"changeOut",helpers:{overlay:{speedIn:0,speedOut:300,opacity:.8,css:{cursor:"pointer"},closeClick:!0},title:{type:"float"}},onCancel:c.noop,beforeLoad:c.noop,afterLoad:c.noop,beforeShow:c.noop,afterShow:c.noop,beforeClose:c.noop,afterClose:c.noop},group:{},opts:{},coming:null,current:null,isOpen:!1,isOpened:!1,wrap:null,skin:null,outer:null,inner:null,player:{timer:null,isActive:!1},ajaxLoad:null,imgPreload:null,transitions:{},helpers:{},open:function(a,b){g.close(!0),a&&!c.isArray(a)&&(a=a instanceof c?c(a).get():[a]),g.isActive=!0,g.opts=c.extend(!0,{},g.defaults,b),c.isPlainObject(b)&&b.keys!==d&&(g.opts.keys=b.keys?c.extend({},g.defaults.keys,b.keys):!1),g.group=a,g._start(g.opts.index||0)},cancel:function(){if(g.coming&&!1===g.trigger("onCancel"))return;g.coming=null,g.hideLoading(),g.ajaxLoad&&g.ajaxLoad.abort(),g.ajaxLoad=null,g.imgPreload&&(g.imgPreload.onload=g.imgPreload.onabort=g.imgPreload.onerror=null)},close:function(a){g.cancel();if(!g.current||!1===g.trigger("beforeClose"))return;g.unbindEvents(),!g.isOpen||a&&a[0]===!0?(c(".fancybox-wrap").stop().trigger("onReset").remove(),g._afterZoomOut()):(g.isOpen=g.isOpened=!1,c(".fancybox-item, .fancybox-nav").remove(),g.wrap.stop(!0).removeClass("fancybox-opened"),g.inner.css("overflow","hidden"),g.transitions[g.current.closeMethod]())},play:function(a){var b=function(){clearTimeout(g.player.timer)},d=function(){b(),g.current&&g.player.isActive&&(g.player.timer=setTimeout(g.next,g.current.playSpeed))},e=function(){b(),c("body").unbind(".player"),g.player.isActive=!1,g.trigger("onPlayEnd")},f=function(){g.current&&(g.current.loop||g.current.index<g.group.length-1)&&(g.player.isActive=!0,c("body").bind({"afterShow.player onUpdate.player":d,"onCancel.player beforeClose.player":e,"beforeLoad.player":b}),d(),g.trigger("onPlayStart"))};g.player.isActive||a&&a[0]===!1?e():f()},next:function(){g.current&&g.jumpto(g.current.index+1)},prev:function(){g.current&&g.jumpto(g.current.index-1)},jumpto:function(a){if(!g.current)return;a=parseInt(a,10),g.group.length>1&&g.current.loop&&(a>=g.group.length?a=0:a<0&&(a=g.group.length-1)),g.group[a]!==d&&(g.cancel(),g._start(a))},reposition:function(a,b){var c;g.isOpen&&(c=g._getPosition(b),a&&a.type==="scroll"?(delete c.position,g.wrap.stop(!0,!0).animate(c,200)):g.wrap.css(c))},update:function(a){if(!g.isOpen)return;h||(i=setTimeout(function(){var b=g.current,c=!a||a&&a.type==="orientationchange";if(h){h=!1;if(!b)return;if(!a||a.type!=="scroll"||c)b.autoSize&&b.type!=="iframe"&&(g.inner.height("auto"),b.height=g.inner.height()),(b.autoResize||c)&&g._setDimension(),b.canGrow&&b.type!=="iframe"&&g.inner.height("auto");(b.autoCenter||c)&&g.reposition(a),g.trigger("onUpdate")}},200)),h=!0},toggle:function(){g.isOpen&&(g.current.fitToView=!g.current.fitToView,g.update())},hideLoading:function(){f.unbind("keypress.fb"),c("#fancybox-loading").remove()},showLoading:function(){g.hideLoading(),f.bind("keypress.fb",function(a){a.keyCode===27&&(a.preventDefault(),g.cancel())}),c('<div id="fancybox-loading"><div></div></div>').click(g.cancel).appendTo("body")},getViewport:function(){return{x:e.scrollLeft(),y:e.scrollTop(),w:j&&a.innerWidth?a.innerWidth:e.width(),h:j&&a.innerHeight?a.innerHeight:e.height()}},unbindEvents:function(){g.wrap&&g.wrap.unbind(".fb"),f.unbind(".fb"),e.unbind(".fb")},bindEvents:function(){var a=g.current,b=a.keys;if(!a)return;e.bind("resize.fb orientationchange.fb"+(a.autoCenter&&!a.fixed?" scroll.fb":""),g.update),b&&f.bind("keydown.fb",function(a){var d,e=a.target||a.srcElement;!a.ctrlKey&&!a.altKey&&!a.shiftKey&&!a.metaKey&&(!e||!e.type&&!c(e).is("[contenteditable]"))&&(d=a.keyCode,c.inArray(d,b.close)>-1?(g.close(),a.preventDefault()):c.inArray(d,b.next)>-1?(g.next(),a.preventDefault()):c.inArray(d,b.prev)>-1&&(g.prev(),a.preventDefault()))}),c.fn.mousewheel&&a.mouseWheel&&g.group.length>1&&g.wrap.bind("mousewheel.fb",function(a,b){var c=a.target||null;b!==0&&(!c||c.clientHeight===0||c.scrollHeight===c.clientHeight&&c.scrollWidth===c.clientWidth)&&(a.preventDefault(),g[b>0?"prev":"next"]())})},trigger:function(a,b){var d,e=b||g[c.inArray(a,["onCancel","beforeLoad","afterLoad"])>-1?"coming":"current"];if(!e)return;c.isFunction(e[a])&&(d=e[a].apply(e,Array.prototype.slice.call(arguments,1)));if(d===!1)return!1;e.helpers&&c.each(e.helpers,function(b,d){d&&c.isPlainObject(g.helpers[b])&&c.isFunction(g.helpers[b][a])&&g.helpers[b][a](d,e)}),c.event.trigger(a+".fb")},isImage:function(a){return k(a)&&a.match(/\.(jpe?g|gif|png|bmp)((\?|#).*)?$/i)},isSWF:function(a){return k(a)&&a.match(/\.(swf)((\?|#).*)?$/i)},_start:function(a){var b={},d=g.group[a]||null,e,f,h,i,j;d&&(d.nodeType||d instanceof c)&&(e=!0,c.metadata&&(b=c(d).metadata())),b=c.extend(!0,{},g.opts,{index:a,element:d},c.isPlainObject(d)?d:b),c.each(["href","title","content","type"],function(a,f){b[f]=g.opts[f]||e&&c(d).attr(f)||b[f]||null}),typeof b.margin=="number"&&(b.margin=[b.margin,b.margin,b.margin,b.margin]),b.modal&&c.extend(!0,b,{closeBtn:!1,closeClick:!1,nextClick:!1,arrows:!1,mouseWheel:!1,keys:null,helpers:{overlay:{css:{cursor:"auto"},closeClick:!1}}}),g.coming=b;if(!1===g.trigger("beforeLoad")){g.coming=null;return}h=b.type,f=b.href||d,h||(e&&(h=c(d).data("fancybox-type"),h||(i=d.className.match(/fancybox\.(\w+)/),h=i?i[1]:null)),!h&&k(f)&&(g.isImage(f)?h="image":g.isSWF(f)?h="swf":f.match(/^#/)&&(h="inline")),h||(h=e?"inline":"html"),b.type=h);if(h==="inline"||h==="html"){b.content||(h==="inline"?b.content=c(k(f)?f.replace(/.*(?=#[^\s]+$)/,""):f):b.content=d);if(!b.content||!b.content.length)h=null}else f||(h=null);h==="ajax"&&k(f)&&(j=f.split(/\s+/,2),f=j.shift(),b.selector=j.shift()),b.href=f,b.group=g.group,b.isDom=e;switch(h){case"image":g._loadImage();break;case"ajax":g._loadAjax();break;case"inline":case"iframe":case"swf":case"html":g._afterLoad();break;default:g._error("type")}},_error:function(a){g.hideLoading(),c.extend(g.coming,{type:"html",autoSize:!0,minWidth:0,minHeight:0,padding:15,hasError:a,content:g.coming.tpl.error}),g._afterLoad()},_loadImage:function(){var a=g.imgPreload=new Image;a.onload=function(){this.onload=this.onerror=null,g.coming.width=this.width,g.coming.height=this.height,g._afterLoad()},a.onerror=function(){this.onload=this.onerror=null,g._error("image")},a.src=g.coming.href,(a.complete===d||!a.complete)&&g.showLoading()},_loadAjax:function(){g.showLoading(),g.ajaxLoad=c.ajax(c.extend({},g.coming.ajax,{url:g.coming.href,error:function(a,b){g.coming&&b!=="abort"?g._error("ajax",a):g.hideLoading()},success:function(a,b){b==="success"&&(g.coming.content=a,g._afterLoad())}}))},_preloadImages:function(){var a=g.group,b=g.current,d=a.length,e,f,h,i=Math.min(b.preload,d-1);if(!b.preload||a.length<2)return;for(h=1;h<=i;h+=1){e=a[(b.index+h)%d],f=e.href||c(e).attr("href")||e;if(e.type==="image"||g.isImage(f))(new Image).src=f}},_afterLoad:function(){g.hideLoading();if(!g.coming||!1===g.trigger("afterLoad",g.current)){g.coming=!1;return}g.isOpened?(c(".fancybox-item, .fancybox-nav").remove(),g.wrap.stop(!0).removeClass("fancybox-opened"),g.inner.css("overflow","hidden"),g.transitions[g.current.prevMethod]()):(c(".fancybox-wrap").stop().trigger("onReset").remove(),g.trigger("afterClose")),g.unbindEvents(),g.isOpen=!1,g.current=g.coming,g.wrap=c(g.current.tpl.wrap).addClass("fancybox-"+(j?"mobile":"desktop")+" fancybox-type-"+g.current.type+" fancybox-tmp "+g.current.wrapCSS).appendTo("body"),g.skin=c(".fancybox-skin",g.wrap).css("padding",m(g.current.padding)),g.outer=c(".fancybox-outer",g.wrap),g.inner=c(".fancybox-inner",g.wrap),g._setContent()},_setContent:function(){var a=g.current,b=a.content,d=a.type,e=a.minWidth,f=a.minHeight,h=a.maxWidth,i=a.maxHeight,k;switch(d){case"inline":case"ajax":case"html":a.selector?b=c("<div>").html(b).find(a.selector):b instanceof c&&(b.parent().hasClass("fancybox-inner")&&b.parents(".fancybox-wrap").unbind("onReset"),b=b.show().detach(),c(g.wrap).bind("onReset",function(){b.appendTo("body").hide()})),a.autoSize&&(k=c('<div class="fancybox-wrap '+g.current.wrapCSS+' fancybox-tmp"></div>').appendTo("body").css({minWidth:m(e,"w"),minHeight:m(f,"h"),maxWidth:m(h,"w"),maxHeight:m(i,"h")}).append(b),a.width=k.width(),a.height=k.height(),k.width(g.current.width),k.height()>a.height&&(k.width(a.width+1),a.width=k.width(),a.height=k.height()),b=k.contents().detach(),k.remove());break;case"image":b=a.tpl.image.replace("{href}",a.href),a.aspectRatio=!0;break;case"swf":b=a.tpl.swf.replace(/\{width\}/g,a.width).replace(/\{height\}/g,a.height).replace(/\{href\}/g,a.href);break;case"iframe":b=c(a.tpl.iframe.replace("{rnd}",(new Date).getTime())).attr("scrolling",a.scrolling).attr("src",a.href),a.scrolling=j?"scroll":"auto"}if(d==="image"||d==="swf")a.autoSize=!1,a.scrolling="visible";d==="iframe"&&a.autoSize?(g.showLoading(),g._setDimension(),g.inner.css("overflow",a.scrolling),b.bind({onCancel:function(){c(this).unbind(),g._afterZoomOut()},load:function(){g.hideLoading();try{this.contentWindow.document.location&&(g.current.height=c(this).contents().find("body").height())}catch(a){g.current.autoSize=!1}g[g.isOpen?"_afterZoomIn":"_beforeShow"]()}}).appendTo(g.inner)):(g.inner.append(b),g._beforeShow())},_beforeShow:function(){g.coming=null,g.trigger("beforeShow"),g._setDimension(),g.wrap.hide().removeClass("fancybox-tmp"),g.bindEvents(),g._preloadImages(),g.transitions[g.isOpened?g.current.nextMethod:g.current.openMethod]()},_setDimension:function(){var a=g.wrap,b=g.inner,d=g.current,e=g.getViewport(),f=d.margin,h=d.padding*2,i=d.width,j=d.height,k=d.maxWidth+h,n=d.maxHeight+h,o=d.minWidth+h,p=d.minHeight+h,q,r;e.w-=f[1]+f[3],e.h-=f[0]+f[2],l(i)&&(i=(e.w-h)*parseFloat(i)/100),l(j)&&(j=(e.h-h)*parseFloat(j)/100),q=i/j,i+=h,j+=h,d.fitToView&&(k=Math.min(e.w,k),n=Math.min(e.h,n)),d.aspectRatio?(i>k&&(i=k,j=(i-h)/q+h),j>n&&(j=n,i=(j-h)*q+h),i<o&&(i=o,j=(i-h)/q+h),j<p&&(j=p,i=(j-h)*q+h)):(i=Math.max(o,Math.min(i,k)),j=Math.max(p,Math.min(j,n))),i=Math.round(i),j=Math.round(j),c(a.add(b)).width("auto").height("auto"),b.width(i-h).height(j-h),a.width(i),r=a.height();if(i>k||r>n)while((i>k||r>n)&&i>o&&r>p)j-=10,d.aspectRatio?(i=Math.round((j-h)*q+h),i<o&&(i=o,j=(i-h)/q+h)):i-=10,b.width(i-h).height(j-h),a.width(i),r=a.height();d.dim={width:m(i),height:m(r)},d.canGrow=d.autoSize&&j>p&&j<n,d.canShrink=!1,d.canExpand=!1,i-h<d.width||j-h<d.height?d.canExpand=!0:(i>e.w||r>e.h)&&i>o&&j>p&&(d.canShrink=!0),g.innerSpace=r-h-b.height()},_getPosition:function(a){var b=g.current,c=g.getViewport(),d=b.margin,e=g.wrap.width()+d[1]+d[3],f=g.wrap.height()+d[0]+d[2],h={position:"absolute",top:d[0]+c.y,left:d[3]+c.x};return b.autoCenter&&b.fixed&&!a&&f<=c.h&&e<=c.w&&(h={position:"fixed",top:d[0],left:d[3]}),h.top=m(Math.max(h.top,h.top+(c.h-f)*b.topRatio)),h.left=m(Math.max(h.left,h.left+(c.w-e)*.5)),h},_afterZoomIn:function(){var a=g.current,b=a?a.scrolling:"no";if(!a)return;g.isOpen=g.isOpened=!0,g.wrap.addClass("fancybox-opened"),g.inner.css("overflow",b==="yes"?"scroll":b==="no"?"hidden":b),g.trigger("afterShow"),g.update(),(a.closeClick||a.nextClick)&&g.inner.css("cursor","pointer").bind("click.fb",function(b){!c(b.target).is("a")&&!c(b.target).parent().is("a")&&g[a.closeClick?"close":"next"]()}),a.closeBtn&&c(a.tpl.closeBtn).appendTo(g.skin).bind("click.fb",g.close),a.arrows&&g.group.length>1&&((a.loop||a.index>0)&&c(a.tpl.prev).appendTo(g.outer).bind("click.fb",g.prev),(a.loop||a.index<g.group.length-1)&&c(a.tpl.next).appendTo(g.outer).bind("click.fb",g.next)),g.opts.autoPlay&&!g.player.isActive&&(g.opts.autoPlay=!1,g.play())},_afterZoomOut:function(){var a=g.current;g.wrap.trigger("onReset").remove(),c.extend(g,{group:{},opts:{},current:null,isActive:!1,isOpened:!1,isOpen:!1,wrap:null,skin:null,outer:null,inner:null}),g.trigger("afterClose",a)}}),g.transitions={getOrigPosition:function(){var a=g.current,b=a.element,d=a.padding,e=c(a.orig),f={},h=50,i=50,j;return!e.length&&a.isDom&&c(b).is(":visible")&&(e=c(b).find("img:first"),e.length||(e=c(b))),e.length?(f=e.offset(),e.is("img")&&(h=e.outerWidth(),i=e.outerHeight())):(j=g.getViewport(),f.top=j.y+(j.h-i)*.5,f.left=j.x+(j.w-h)*.5),f={top:m(f.top-d),left:m(f.left-d),width:m(h+d*2),height:m(i+d*2)},f},step:function(a,b){var c=b.prop,d,e;if(c==="width"||c==="height")d=Math.ceil(a-g.current.padding*2),c==="height"&&(e=(a-b.start)/(b.end-b.start),b.start>b.end&&(e=1-e),d-=g.innerSpace*e),g.inner[c](d)},zoomIn:function(){var a=g.wrap,b=g.current,d=b.openEffect,e=d==="elastic",f=b.dim,h=c.extend({},f,g._getPosition(e)),i=c.extend({opacity:1},h);delete i.position,e?(h=this.getOrigPosition(),b.openOpacity&&(h.opacity=0),g.outer.add(g.inner).width("auto").height("auto")):d==="fade"&&(h.opacity=0),a.css(h).show().animate(i,{duration:d==="none"?0:b.openSpeed,easing:b.openEasing,step:e?this.step:null,complete:g._afterZoomIn})},zoomOut:function(){var a=g.wrap,b=g.current,c=b.openEffect,d=c==="elastic",e={opacity:0};d&&(a.css("position")==="fixed"&&a.css(g._getPosition(!0)),e=this.getOrigPosition(),b.closeOpacity&&(e.opacity=0)),a.animate(e,{duration:c==="none"?0:b.closeSpeed,easing:b.closeEasing,step:d?this.step:null,complete:g._afterZoomOut})},changeIn:function(){var a=g.wrap,b=g.current,c=b.nextEffect,d=c==="elastic",e=g._getPosition(d),f={opacity:1};e.opacity=0,d&&(e.top=m(parseInt(e.top,10)-200),f.top="+=200px"),a.css(e).show().animate(f,{duration:c==="none"?0:b.nextSpeed,easing:b.nextEasing,complete:g._afterZoomIn})},changeOut:function(){var a=g.wrap,b=g.current,d=b.prevEffect,e={opacity:0},f=function(){c(this).trigger("onReset").remove()};a.removeClass("fancybox-opened"),d==="elastic"&&(e.top="+=200px"),a.animate(e,{duration:d==="none"?0:b.prevSpeed,easing:b.prevEasing,complete:f})}},g.helpers.overlay={overlay:null,update:function(){var a,d,g;this.overlay.width("100%").height("100%"),c.browser.msie||j?(d=Math.max(b.documentElement.scrollWidth,b.body.scrollWidth),g=Math.max(b.documentElement.offsetWidth,b.body.offsetWidth),a=d<g?e.width():d):a=f.width(),this.overlay.width(a).height(f.height())},beforeShow:function(a){if(this.overlay)return;a=c.extend(!0,{},g.defaults.helpers.overlay,a),this.overlay=c('<div id="fancybox-overlay"></div>').css(a.css).appendTo("body"),a.closeClick&&this.overlay.bind("click.fb",g.close),g.current.fixed&&!j?this.overlay.addClass("overlay-fixed"):(this.update(),this.onUpdate=function(){this.update()}),this.overlay.fadeTo(a.speedIn,a.opacity)},afterClose:function(a){this.overlay&&this.overlay.fadeOut(a.speedOut||0,function(){c(this).remove()}),this.overlay=null}},g.helpers.title={beforeShow:function(a){var b,d=g.current.title;d&&(b=c('<div class="fancybox-title fancybox-title-'+a.type+'-wrap">'+d+"</div>").appendTo("body"),a.type==="float"&&(b.width(b.width()),b.wrapInner('<span class="child"></span>'),g.current.margin[2]+=Math.abs(parseInt(b.css("margin-bottom"),10))),b.appendTo(a.type==="over"?g.inner:a.type==="outside"?g.wrap:g.skin))}},c.fn.fancybox=function(a){var b=c(this),d=this.selector||"",e,h=function(f){var h=this,i=e,j,k;!(f.ctrlKey||f.altKey||f.shiftKey||f.metaKey)&&!c(h).is(".fancybox-wrap")&&(f.preventDefault(),j=a.groupAttr||"data-fancybox-group",k=c(h).attr(j),k||(j="rel",k=h[j]),k&&k!==""&&k!=="nofollow"&&(h=d.length?c(d):b,h=h.filter("["+j+'="'+k+'"]'),i=h.index(this)),a.index=i,g.open(h,a))};return a=a||{},e=a.index||0,d?f.undelegate(d,"click.fb-start").delegate(d,"click.fb-start",h):b.unbind("click.fb-start").bind("click.fb-start",h),this},c(b).ready(function(){g.defaults.fixed=c.support.fixedPosition||!(c.browser.msie&&c.browser.version<=6)&&!j})}(window,document,jQuery),$(function(){function d(){if(!b)return;for(var d=0;d<c;d++){var e=b[d];e.element.innerHTML=e.name}for(var d=0,f=a.length;d<f;d++)a[d].container.style.display="block"}var a=[];$(".name").each(function(){var b=$(this);a.push({element:b[0],name:b.html(),container:b.parents("li")[0]})});var b=new Array(a.length),c=0;$("#filter").focus(),$("#filter").keyup(function(){d();var e=new RegExp(this.value,"i");c=0;for(var f=0,g=a.length;f<g;f++){var h=a[f];text=h.name.match(e),text?(h.element.innerHTML=h.name.replace(text,"<span>"+text+"</span>"),b[c++]=h):h.container.style.display="none"}})}),$(function(){function e(){var b=!1;for(var c=1;c<a;++c){var d=f(c);d==-1&&(b=!0)}$(".edit_artist").data("errors",b)}function f(b){if(b==a)return;var c=1,d=!1;$(".edit_artist").children(":nth-child("+parseInt(b)+")").find(":input:not(button)").each(function(){var a=$(this),b=jQuery.trim(a.val()).length;b==""?(d=!0,a.css("background-color","#FFEDEF")):a.css("background-color","#FFFFFF")});var e=$("#navigation li:nth-child("+parseInt(b)+") a");e.parent().find(".error,.checked").remove();var f="checked";return d&&(c=-1,f="error"),$('<span class="'+f+'"></span>').insertAfter(e),c}var a=$(".edit_artist").children().length,b=1,c=0,d=new Array;$("#steps .step").each(function(a){var b=$(this);d[a]=c,c+=b.width()}),$("#steps").width(c),$(".edit_artist").children(":first").find(":input:first").focus(),$("#navigation").show(),$("#navigation a").bind("click",function(c){var g=$(this),h=b;g.closest("ul").find("li").removeClass("selected"),g.parent().addClass("selected"),b=g.parent().index()+1,$("#steps").stop().animate({marginLeft:"-"+d[b-1]+"px"},500,function(){b==a?e():f(h),$(".edit_artist").children(":nth-child("+parseInt(b)+")").find(":input:first").focus()}),c.preventDefault()}),$(".edit_artist > fieldset").each(function(){var a=$(this);a.children(":last").find(":li").keydown(function(a){a.which==9&&($("#navigation li:nth-child("+(parseInt(b)+1)+") a").click(),$(this).blur(),a.preventDefault())})}),$("#registerButton").bind("click",function(){if($(".edit_artist").data("errors"))return alert("Please correct the errors in the Form"),!1})}),jQuery.fn.extend({everyTime:function(a,b,c,d,e){return this.each(function(){jQuery.timer.add(this,a,b,c,d,e)})},oneTime:function(a,b,c){return this.each(function(){jQuery.timer.add(this,a,b,c,1)})},stopTime:function(a,b){return this.each(function(){jQuery.timer.remove(this,a,b)})}}),jQuery.extend({timer:{guid:1,global:{},regex:/^([0-9]+)\s*(.*s)?$/,powers:{ms:1,cs:10,ds:100,s:1e3,das:1e4,hs:1e5,ks:1e6},timeParse:function(a){if(a==undefined||a==null)return null;var b=this.regex.exec(jQuery.trim(a.toString()));if(b[2]){var c=parseInt(b[1],10),d=this.powers[b[2]]||1;return c*d}return a},add:function(a,b,c,d,e,f){var g=0;jQuery.isFunction(c)&&(e||(e=d),d=c,c=b),b=jQuery.timer.timeParse(b);if(typeof b!="number"||isNaN(b)||b<=0)return;e&&e.constructor!=Number&&(f=!!e,e=0),e=e||0,f=f||!1,a.$timers||(a.$timers={}),a.$timers[c]||(a.$timers[c]={}),d.$timerID=d.$timerID||this.guid++;var h=function(){if(f&&this.inProgress)return;this.inProgress=!0,(++g>e&&e!==0||d.call(a,g)===!1)&&jQuery.timer.remove(a,c,d),this.inProgress=!1};h.$timerID=d.$timerID,a.$timers[c][d.$timerID]||(a.$timers[c][d.$timerID]=window.setInterval(h,b)),this.global[c]||(this.global[c]=[]),this.global[c].push(a)},remove:function(a,b,c){var d=a.$timers,e;if(d){if(!b)for(b in d)this.remove(a,b,c);else if(d[b]){if(c)c.$timerID&&(window.clearInterval(d[b][c.$timerID]),delete d[b][c.$timerID]);else for(var c in d[b])window.clearInterval(d[b][c]),delete d[b][c];for(e in d[b])break;e||(e=null,delete d[b])}for(e in d)break;e||(a.$timers=null)}}}}),jQuery.browser.msie&&jQuery(window).one("unload",function(){var a=jQuery.timer.global;for(var b in a){var c=a[b],d=c.length;while(--d)jQuery.timer.remove(c[d],b)}}),$(document).ready(function(){$("#delete-account a").fancybox({width:431,height:286,autoSize:!1,closeClick:!1})});