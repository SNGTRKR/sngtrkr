(function(){var a;a=jQuery,a(document).ready(function(){return window.nestedFormEvents.insertFields=function(b,c,d){var e;return e=a(d).closest(".controls").siblings(".tab-content"),e.append(b),e.children().last()}}),a("form").live("nested:fieldAdded",function(b){var c,d,e,f,g,h;return d=b.field.addClass("tab-pane"),f=a('<li><a data-toggle="tab" href="#'+d.attr("id")+'">'+d.children(".object-infos").data("object-label")+"</a></li>"),g=d.closest(".control-group"),c=g.children(".controls"),e=c.children(".nav"),b=g.children(".tab-content"),h=c.find(".toggler"),e.append(f),a(window.document).trigger("rails_admin.dom_ready"),f.children("a").tab("show"),e.select(":hidden").show("slow"),b.select(":hidden").show("slow"),h.addClass("active").removeClass("disabled").children("i").addClass("icon-chevron-down").removeClass("icon-chevron-right")}),a("form").live("nested:fieldRemoved",function(a){var b,c,d,e,f,g;d=a.field,e=d.closest(".control-group").children(".controls").children(".nav"),c=e.children("li").has("a[href=#"+d.attr("id")+"]"),f=d.closest(".control-group"),b=f.children(".controls"),g=b.find(".toggler"),(c.next().length?c.next():c.prev()).children("a:first").tab("show"),c.remove();if(e.children().length===0)return e.select(":visible").hide("slow"),g.removeClass("active").addClass("disabled").children("i").removeClass("icon-chevron-down").addClass("icon-chevron-right")})}).call(this);