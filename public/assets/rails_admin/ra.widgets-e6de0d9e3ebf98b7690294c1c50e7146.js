(function(){$(document).live("rails_admin.dom_ready",function(){if($("form").length)return $("[data-color]").each(function(){var a;return a=this,$(this).ColorPicker({color:$(a).val(),onShow:function(a){return $(a).fadeIn(500),!1},onHide:function(a){return $(a).fadeOut(500),!1},onChange:function(b,c,d){return $(a).val(c),$(a).css("backgroundColor","#"+c)}})}),$("[data-datetimepicker]").each(function(){return $(this).datetimepicker($(this).data("options"))}),$("[data-enumeration]").each(function(){return $(this).filteringSelect($(this).data("options"))}),$("[data-fileupload]").each(function(){var a;return a=this,$(this).find(".delete input[type='checkbox']").live("click",function(){return $(a).children(".toggle").toggle("slow")})}),$("[data-filteringmultiselect]").each(function(){return $(this).filteringMultiselect($(this).data("options")),$(this).parents("#modal").length?$(this).parents(".control-group").find(".btn").remove():$(this).parents(".control-group").first().remoteForm()}),$("[data-filteringselect]").each(function(){return $(this).filteringSelect($(this).data("options")),$(this).parents("#modal").length?$(this).parents(".control-group").find(".btn").remove():$(this).parents(".control-group").first().remoteForm()}),$("[data-nestedmany]").each(function(){var a,b,c,d;return b=$(this).parents(".control-group").first(),c=b.find("> .controls > .nav"),a=b.find("> .tab-content"),d=b.find("> .controls > .btn-group > .toggler"),a.children(".fields:not(.tab-pane)").addClass("tab-pane").each(function(){return c.append('<li><a data-toggle="tab" href="#'+this.id+'">'+$(this).children(".object-infos").data("object-label")+"</a></li>")}),c.find("> li > a[data-toggle='tab']:first").tab("show"),c.children().length===0?(c.hide(),a.hide(),d.addClass("disabled").removeClass("active").children("i").addClass("icon-chevron-right")):d.hasClass("active")?(c.show(),a.show(),d.children("i").addClass("icon-chevron-down")):(c.hide(),a.hide(),d.children("i").addClass("icon-chevron-right"))}),$("[data-nestedone]").each(function(){var a,b,c,d,e;return b=$(this).parents(".control-group").first(),d=b.find("> .controls > .nav"),a=b.find("> .tab-content"),e=b.find("> .controls > .toggler"),a.children(".fields:not(.tab-pane)").addClass("tab-pane").each(function(){return d.append('<li><a data-toggle="tab" href="#'+this.id+'">'+$(this).children(".object-infos").data("object-label")+"</a></li>")}),c=d.find("> li > a[data-toggle='tab']:first"),c.tab("show"),b.find("> .controls > [data-target]:first").html('<i class="icon-white"></i> '+c.html()),e.hasClass("active")?(e.children("i").addClass("icon-chevron-down"),a.show()):(e.children("i").addClass("icon-chevron-right"),a.hide())}),$("[data-polymorphic]").each(function(){var a,b,c,d;return c=$(this),a=c.parents(".control-group").first(),b=a.find("select").last(),d=c.data("urls"),c.on("change",function(a){return $(this).val()===""?b.html('<option value=""></option>'):$.ajax({url:d[c.val()],data:{compact:!0,all:!0},beforeSend:function(a){return a.setRequestHeader("Accept","application/json")},success:function(a,c,d){var e;return e="<option></option>",$(a).each(function(a,b){return e+='<option value="'+b.id+'">'+b.label+"</option>"}),b.html(e)}})})}),$("[data-richtext=ckeditor]").each(function(){var a,b;return window.CKEDITOR_BASEPATH="/assets/ckeditor/",b=$(this).data("options"),window.CKEDITOR||$(window.document).append('<script src="'+b.jspath+'"></script>'),(a=window.CKEDITOR.instances[this.id])&&window.CKEDITOR.remove(a),window.CKEDITOR.replace(this,b.options)})})}).call(this);