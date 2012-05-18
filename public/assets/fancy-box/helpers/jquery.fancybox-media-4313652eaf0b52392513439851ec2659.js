/*!
 * Media helper for fancyBox
 * version: 1.0.0
 * @requires fancyBox v2.0 or later
 *
 * Usage:
 *     $(".fancybox").fancybox({
 *         media: {}
 *     });
 *
 *  Supports:
 *      Youtube
 *          http://www.youtube.com/watch?v=opj24KnzrWo
 *          http://youtu.be/opj24KnzrWo
 *      Vimeo
 *          http://vimeo.com/25634903
 *      Metacafe
 *          http://www.metacafe.com/watch/7635964/dr_seuss_the_lorax_movie_trailer/
 *          http://www.metacafe.com/watch/7635964/
 *      Dailymotion
 *          http://www.dailymotion.com/video/xoytqh_dr-seuss-the-lorax-premiere_people
 *      Twitvid
 *          http://twitvid.com/QY7MD
 *      Twitpic
 *          http://twitpic.com/7p93st
 *      Instagram
 *          http://instagr.am/p/IejkuUGxQn/
 *          http://instagram.com/p/IejkuUGxQn/
 *      Google maps
 *          http://maps.google.com/maps?q=Eiffel+Tower,+Avenue+Gustave+Eiffel,+Paris,+France&t=h&z=17
 *          http://maps.google.com/?ll=48.857995,2.294297&spn=0.007666,0.021136&t=m&z=16
 *          http://maps.google.com/?ll=48.859463,2.292626&spn=0.000965,0.002642&t=m&z=19&layer=c&cbll=48.859524,2.292532&panoid=YJ0lq28OOy3VT2IqIuVY0g&cbp=12,151.58,,0,-15.56
 */
(function(a){var b=a.fancybox;b.helpers.media={beforeLoad:function(a,b){var c=b.href||"",d=!1,e;if(e=c.match(/(youtube\.com|youtu\.be)\/(v\/|u\/|embed\/|watch\?v=)?([^#\&\?]*).*/i))c="//www.youtube.com/embed/"+e[3]+"?autoplay=1&autohide=1&fs=1&rel=0&enablejsapi=1",d="iframe";else if(e=c.match(/vimeo.com\/(\d+)\/?(.*)/))c="//player.vimeo.com/video/"+e[1]+"?hd=1&autoplay=1&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1",d="iframe";else if(e=c.match(/metacafe.com\/watch\/(\d+)\/?(.*)/))c="//www.metacafe.com/fplayer/"+e[1]+"/.swf?playerVars=autoPlay=yes",d="swf";else if(e=c.match(/dailymotion.com\/video\/(.*)\/?(.*)/))c="//www.dailymotion.com/swf/video/"+e[1]+"?additionalInfos=0&autoStart=1",d="swf";else if(e=c.match(/twitvid\.com\/([a-zA-Z0-9_\-\?\=]+)/i))c="//www.twitvid.com/embed.php?autoplay=0&guid="+e[1],d="iframe";else if(e=c.match(/twitpic\.com\/(?!(?:place|photos|events)\/)([a-zA-Z0-9\?\=\-]+)/i))c="//twitpic.com/show/full/"+e[1],d="image";else if(e=c.match(/(instagr\.am|instagram\.com)\/p\/([a-zA-Z0-9_\-]+)\/?/i))c="//"+e[1]+"/p/"+e[2]+"/media/?size=l",d="image";else if(e=c.match(/maps\.google\.com\/(\?ll=|maps\/?\?q=)(.*)/i))c="//maps.google.com/"+e[1]+""+e[2]+"&output="+(e[2].indexOf("layer=c")?"svembed":"embed"),d="iframe";d&&(b.href=c,b.type=d)}}})(jQuery);