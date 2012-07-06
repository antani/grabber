/*
 * Feedback (for jQuery)
 * version: 0.1 (2009-07-21)
 * @requires jQuery v1.3 or later
 *
 * This script is part of the Feedback Ruby on Rails Plugin:
 *   http://
 *
 * Licensed under the MIT:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2009 Jean-Sebastien Boulanger [ jsboulanger@gmail.com ]
 *
 * Usage:
 *
 *  jQuery(document).ready(function() {
 *    jQuery('#feedback_tab_link').feedback({
 *      // options
 *    });
 *  })
 *
 */
(function(a){var b;a.fn.feedback=function(d){b=a.extend({main:"feedback",closeLink:"feedback_close_link",modalWindow:"feedback_modal_window",modalContent:"feedback_modal_content",form:"feedback_form",formUrl:"/feedbacks/new",overlay:"feedback_overlay",loadingImage:"/assets/feedback/loading.gif",loadingText:"Loading...",sendingText:"Sending...",tabPosition:"left"},d||{}),b.feedbackHtml='<div id="'+b.main+'" style="display: none;">'+'<div id="'+b.modalWindow+'">'+'<a href="#" id="'+b.closeLink+'"></a>'+'<div id="'+b.modalContent+'"></div>'+"</div>"+"</div>",b.overlayHtml='<div id="'+b.overlay+'" class="feedback_hide"></div>',b.tabHtml='<a href="#" id="feedback_link" class="feedback_link '+b.tabPosition+'"></a>',b.main="#"+b.main,b.closeLink="#"+b.closeLink,b.modalWindow="#"+b.modalWindow,b.modalContent="#"+b.modalContent,b.form="#"+b.form,b.overlay="#"+b.overlay,b.tabControls=this,b.tabPosition!=null&&a("#feedback_link").length==0&&(a("body").append(b.tabHtml),b.tabControls=a(b.tabControls).add(a("#feedback_link"))),a(b.tabControls).click(function(){return k(),a(b.modalContent).load(b.formUrl,null,function(){a(b.form).submit(c)}),!1})};var c=function(){a("input[name=feedback\\[page\\]]").val(location.href);var d=a(b.form).serialize(),e=a.trim(a(b.form).attr("action"));return k(b.sendingText),a.ajax({type:"POST",url:e,data:d,success:function(c,d){a(b.modalContent).html(c),a(b.modalWindow).fadeOut(2e3,function(){i()})},error:function(d,e,f){a(b.modalContent).html(d.responseText),a(b.form).submit(c)}}),!1},d=function(){return a(b.overlay).length==0&&a("body").append(b.overlayHtml),a(b.overlay).hide().addClass("feedback_overlayBG")},e=function(){d().show()},f=function(){if(a(b.overlay).length==0)return!1;a(b.overlay).remove()},g=function(){return a(b.main).length==0&&(a("body").append(b.feedbackHtml),a(b.closeLink).click(function(){return i(),!1}),j()),a(b.main)},h=function(){g().show()},i=function(){a(b.main).hide(),a(b.main).remove(),f()},j=function(){var c,d;self.pageYOffset?c=self.pageYOffset:document.documentElement&&document.documentElement.scrollTop?c=document.documentElement.scrollTop:document.body&&(c=document.body.scrollTop),self.innerHeight?d=self.innerHeight:document.documentElement&&document.documentElement.clientHeight?d=document.documentElement.clientHeight:document.body&&(d=document.body.clientHeight),a(b.modalWindow).css({top:c+d/10+"px"})},k=function(c){e(),g(),c==null&&(c=b.loadingText),a(b.modalContent).html("<h1>"+c+'<img src="'+b.loadingImage+'" /></h1>'),h()}})(jQuery);