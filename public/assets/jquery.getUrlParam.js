/* Copyright (c) 2006-2007 Mathias Bank (http://www.mathias-bank.de)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) 
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 * 
 * Version 2.1
 * 
 * Thanks to 
 * Hinnerk Ruemenapf - http://hinnerk.ruemenapf.de/ for bug reporting and fixing.
 * Tom Leonard for some improvements
 * 
 */
jQuery.fn.extend({getUrlParam:function(a){a=escape(unescape(a));var b=new Array,c=null;if($(this).attr("nodeName")=="#document")window.location.search.search(a)>-1&&(c=window.location.search.substr(1,window.location.search.length).split("&"));else if($(this).attr("src")!="undefined"){var d=$(this).attr("src");if(d.indexOf("?")>-1){var e=d.substr(d.indexOf("?")+1);c=e.split("&")}}else{if($(this).attr("href")=="undefined")return null;var d=$(this).attr("href");if(d.indexOf("?")>-1){var e=d.substr(d.indexOf("?")+1);c=e.split("&")}}if(c==null)return null;for(var f=0;f<c.length;f++)escape(unescape(c[f].split("=")[0]))==a&&b.push(c[f].split("=")[1]);return b.length==0?null:b.length==1?b[0]:b}});