/* =========================================================

// jquery.innerfade.js

// Datum: 2008-02-14
// Firma: Medienfreunde Hofmann & Baldes GbR
// Author: Torsten Baldes
// Mail: t.baldes@medienfreunde.com
// Web: http://medienfreunde.com

// based on the work of Matt Oakes http://portfolio.gizone.co.uk/applications/slideshow/
// and Ralf S. Engelschall http://trainofthoughts.org/

 *
 *  <ul id="news"> 
 *      <li>content 1</li>
 *      <li>content 2</li>
 *      <li>content 3</li>
 *  </ul>
 *  
 *  $('#news').innerfade({ 
 *	  animationtype: Type of animation 'fade' or 'slide' (Default: 'fade'), 
 *	  speed: Fading-/Sliding-Speed in milliseconds or keywords (slow, normal or fast) (Default: 'normal'), 
 *	  timeout: Time between the fades in milliseconds (Default: '2000'), 
 *	  type: Type of slideshow: 'sequence', 'random' or 'random_start' (Default: 'sequence'), 
 * 		containerheight: Height of the containing element in any css-height-value (Default: 'auto'),
 *	  runningclass: CSS-Class which the container get’s applied (Default: 'innerfade'),
 *	  children: optional children selector (Default: null)
 *  }); 
 *

// ========================================================= */
function removeFilter(a){a.style.removeAttribute&&a.style.removeAttribute("filter")}(function(a){a.fn.innerfade=function(b){return this.each(function(){a.innerfade(this,b)})},a.innerfade=function(b,c){var d={animationtype:"fade",speed:"normal",type:"sequence",timeout:2e3,containerheight:"auto",runningclass:"innerfade",children:null};c&&a.extend(d,c);if(d.children===null)var e=a(b).children();else var e=a(b).children(d.children);if(e.length>1){a(b).css("position","relative").css("height",d.containerheight).addClass(d.runningclass);for(var f=0;f<e.length;f++)a(e[f]).css("z-index",String(e.length-f)).css("position","absolute").hide();if(d.type=="sequence")setTimeout(function(){a.innerfade.next(e,d,1,0)},d.timeout),a(e[0]).show();else if(d.type=="random"){var g=Math.floor(Math.random()*e.length);setTimeout(function(){do h=Math.floor(Math.random()*e.length);while(g==h);a.innerfade.next(e,d,h,g)},d.timeout),a(e[g]).show()}else if(d.type=="random_start"){d.type="sequence";var h=Math.floor(Math.random()*e.length);setTimeout(function(){a.innerfade.next(e,d,(h+1)%e.length,h)},d.timeout),a(e[h]).show()}else alert("Innerfade-Type must either be 'sequence', 'random' or 'random_start'")}},a.innerfade.next=function(b,c,d,e){c.animationtype=="slide"?(a(b[e]).slideUp(c.speed),a(b[d]).slideDown(c.speed)):c.animationtype=="fade"?(a(b[e]).fadeOut(c.speed),a(b[d]).fadeIn(c.speed,function(){removeFilter(a(this)[0])})):alert("Innerfade-animationtype must either be 'slide' or 'fade'");if(c.type=="sequence")d+1<b.length?(d+=1,e=d-1):(d=0,e=b.length-1);else if(c.type=="random"){e=d;while(d==e)d=Math.floor(Math.random()*b.length)}else alert("Innerfade-Type must either be 'sequence', 'random' or 'random_start'");setTimeout(function(){a.innerfade.next(b,c,d,e)},c.timeout)}})(jQuery);