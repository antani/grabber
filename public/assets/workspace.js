// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//'#E8E8E2'

$(document).ready(function() {

/*
$("#foo3").carouFredSel({
	curcular: false,
	infinite: false,
	auto : false,
	prev : {	
		button	: "#foo3_prev",
		key		: "left"
	},
	next : { 
		button	: "#foo3_next",
		key		: "right"
	},
	pagination	: "#foo3_pag"
});

*/

$('.tag_dummy:first').removeClass('tag_dummy').addClass("tags");

$('body').noisy({
      'intensity' : 1,
      'size' : 200,
      'opacity' : 0.08,
      'fallback' : '',
      'monochrome' : false
}).css('background-color', '#FBFBF7');

//$(".prod_img").aeImageResize({ height: 135, width: 87 });
$('img.prod_img').each(function(){
    $(this).load(function(){
        var maxWidth = $(this).width(); // Max width for the image
        var maxHeight = $(this).height();       // Max height for the image
        $(this).css("width", "auto").css("height", "auto"); // Remove existing CSS
        $(this).removeAttr("width").removeAttr("height"); // Remove HTML attributes
        var width = $(this).width();    // Current image width
        var height = $(this).height();  // Current image height
 
        if(width > height) {
 
                // Check if the current width is larger than the max
                if(width > maxWidth){
                        var ratio = maxWidth / width;   // get ratio for scaling image
                        $(this).css("width", maxWidth); // Set new width
                        $(this).css("height", height * ratio);  // Scale height based on ratio
                        height = height * ratio;        // Reset height to match scaled image
                }
        } else {
                // Check if current height is larger than max
                if(height > maxHeight){
                        var ratio = maxHeight / height; // get ratio for scaling image
                        $(this).css("height", maxHeight);   // Set new height
                        $(this).css("width", width * ratio);    // Scale width based on ratio
                       width = width * ratio;  // Reset width to match scaled image
                }
        }
    });
});

//If something is searched, preseve that.
search_wat = $(document).getUrlParam("last_search_type"); 
if(search_wat != null)
{
    
    $('#search_type').val(search_wat);    
    
    if(search_wat == "books"){
        $('#searchbooks').addClass('active');
        $('#searchmovies').removeClass('active');
        $('#searchmobiles').removeClass('active');
        $('#searchcamera').removeClass('active');
        $('#searchcomputers').removeClass('active');
    } else if(search_wat == "movies"){
        $('#searchmovies').addClass('active');
        $('#searchbooks').removeClass('active');
        $('#searchmobiles').removeClass('active');
        $('#searchcamera').removeClass('active');
        $('#searchcomputers').removeClass('active');
        
    }else  if(search_wat == "mobiles"){
        $('#searchmobiles').addClass('active');
        $('#searchbooks').removeClass('active');
        $('#searchmovies').removeClass('active');
        $('#searchcamera').removeClass('active');   
        $('#searchcomputers').removeClass('active');     
        
    }else  if(search_wat == "cameras"){
        $('#searchcamera').addClass('active');
        $('#searchbooks').removeClass('active');
        $('#searchmobiles').removeClass('active');
        $('#searchmovies').removeClass('active');
        $('#searchcomputers').removeClass('active');

    }else  if(search_wat == "computers"){
        $('#searchcomputers').addClass('active');
        $('#searchbooks').removeClass('active');
        $('#searchmobiles').removeClass('active');
        $('#searchmovies').removeClass('active');
        $('#searchcamera').removeClass('active');

    }
    
}
$('#search_button').click(function() {
                              mpq.track('Search Clicked');
                         });

$('.purchase a').click(function() {
                              mpq.track('Shopped');
                       });


$('#searchbooks').click(function() {
            $('#search_type,#last_search_type').val('books');
            createCookie("search_what","books",1);
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchmobiles').removeClass('active');
            $('#searchcamera').removeClass('active');
            $('#searchcomputers').removeClass('active');
          });
$('#searchmovies').click(function() {
            $('#search_type,#last_search_type').val('movies');
            createCookie("search_what","movies",1);
            $(this).addClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchmobiles').removeClass('active');
            $('#searchcamera').removeClass('active');
            $('#searchcomputers').removeClass('active');
          });
$('#searchmobiles').click(function() {
            $('#search_type,#last_search_type').val('mobiles');
            createCookie("search_what","mobiles",1);            
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchcamera').removeClass('active');
            $('#searchcomputers').removeClass('active');
          });
$('#searchcamera').click(function() {
            $('#search_type,#last_search_type').val('cameras');
            createCookie("search_what","cameras",1);            
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchmobiles').removeClass('active');
            $('#searchcomputers').removeClass('active');
          });
$('#searchcomputers').click(function() {
            $('#search_type,#last_search_type').val('computers');
            createCookie("search_what","computers",1);            
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchmobiles').removeClass('active');
            $('#searchcamera').removeClass('active');
          });

 function pulsate()
 {
 $(".pulsate").
      animate({opacity: 0.2}, 1000, 'linear').
      animate({opacity: 1}, 1000, 'linear', pulsate);
 }
/* pulsate(); */


$("#search_link").click( function()
	{
		$('#searchsubmit_btn').click();
	});	

$('.btn').append($('<span />').addClass('helper'));

            $(".dropdown dt a").click(function() {
                $(".dropdown dd ul").toggle();
            });
                        
            $(".dropdown dd ul li a").click(function() {
                var text = $(this).html();
                $(".dropdown dt a span").html(text);
                $(".dropdown dd ul").hide();
                $("#result").html("Selected value is: " + getSelectedValue("sample"));
            });
                        
            function getSelectedValue(id) {
                return $("#" + id).find("dt a span.value").html();
            }

            $(document).bind('click', function(e) {
                var $clicked = $(e.target);
                if (! $clicked.parents().hasClass("dropdown"))
                    $(".dropdown dd ul").hide();
            });

function sendMessage(msg)
{
   $().toastmessage('showNoticeToast', msg);
}
            

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}
$('#india-stores').qtip({
   content: 'We search Flipkart, Infibeam, eBay, Rediff, IndiaPlaza, LetsBuy, Pustak, Crossword, A1Books, NBCIndia, BookAdda, TradeUs, Jumadi, HomeShop, FutureBazaar and we are adding new stores',  
   show: 'mouseover',
   hide: 'mouseout',
   style: 'green'
});

function dots(v){
 return v.slice(0,17)+".."
}

$('.comingsoon').qtip({content: 'Coming very very soon', show:'mouseover',hide:'mouseout',style:'green'});

/*--Feedback slidshow----------------*/
//$('#slideshow-reel').innerfade({animationtype: 'slide', speed: 750, timeout: 8000, type: 'random', containerheight: '1em' }); 
        //$('#portfolio').innerfade({ speed: 'slow', timeout: 4000, type: 'sequence', containerheight: '220px' }); 
        //$('.fade').innerfade({ speed: 'slow', timeout: 1000, type: 'sequence', containerheight: '1.5em' }); 


}); //end js  

(function(d){d.fn.aeImageResize=function(a){var i=0,j=d.browser.msie&&6==~~d.browser.version;if(!a.height&&!a.width)return this;if(a.height&&a.width)i=a.width/a.height;return this.one("load",function(){this.removeAttribute("height");this.removeAttribute("width");this.style.height=this.style.width="";var e=this.height,f=this.width,g=f/e,b=a.height,c=a.width,h=i;h||(h=b?g+1:g-1);if(b&&e>b||c&&f>c){if(g>h)b=~~(e/f*c);else c=~~(f/e*b);this.height=b;this.width=c}}).each(function(){if(this.complete||j)d(this).trigger("load")})}})(jQuery);
/*	
 *	jQuery carouFredSel 4.4.1
 *	Demo's and documentation:
 *	caroufredsel.frebsite.nl
 *	
 *	Copyright (c) 2010 Fred Heusschen
 *	www.frebsite.nl
 *
 *	Dual licensed under the MIT and GPL licenses.
 *	http://en.wikipedia.org/wiki/MIT_License
 *	http://en.wikipedia.org/wiki/GNU_General_Public_License
 */

eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(9($){7($.1w.1s)z;$.1w.1s=9(o){7(Z.V==0){P(A,\'4c 5f 5g 1t "\'+Z.5h+\'".\');z Z}7(Z.V>1){z Z.1I(9(){$(Z).1s(o)})}w q=Z,$11=Z[0];q.3C=9(o,b){w c=[\'8\',\'12\',\'K\',\'Q\',\'R\',\'Y\'];o=2Z($11,o);1t(w a=0,l=c.V;a<l;a++){o[c[a]]=2Z($11,o[c[a]])}7(y o.12==\'S\'){7(o.12<=50)o.12={8:o.12};C o.12={1e:o.12}}C{7(y o.12==\'17\')o.12={1j:o.12}}7(y o.8==\'S\')o.8={B:o.8};C 7(o.8==\'1a\')o.8={B:o.8,F:o.8,14:o.8};7(b)24=$.1M(A,{},$.1w.1s.3D,o);6=$.1M(A,{},$.1w.1s.3D,o);6.d={};6.2j=G;6.30=G;1N=(6.1N==\'4d\'||6.1N==\'1b\')?\'R\':\'Q\';w e=[[\'F\',\'31\',\'1O\',\'14\',\'4e\',\'25\',\'1b\',\'2k\',\'1c\',0,1,2,3],[\'14\',\'4e\',\'25\',\'F\',\'31\',\'1O\',\'2k\',\'1b\',\'2l\',3,2,1,0]];w f=e[0].V,4f=(6.1N==\'2B\'||6.1N==\'1b\')?0:1;1t(w d=0;d<f;d++){6.d[e[0][d]]=e[4f][d]}w g=H(q),3E=3F(g,6,\'25\',G);7(6.W==\'K\'){P(A,\'26 5i "W: K" 1m 1P, 1Q "1f: 2C".\');6.W=G;6.1f=\'2C\'}7(6[6.d[\'14\']]==\'K\'){6[6.d[\'14\']]=3E;6.8[6.d[\'14\']]=3E}7(!6.8[6.d[\'F\']]){6.8[6.d[\'F\']]=(3G(g,6,\'1O\'))?\'1a\':g[6.d[\'1O\']](A)}7(!6.8[6.d[\'14\']]){6.8[6.d[\'14\']]=(3G(g,6,\'25\'))?\'1a\':g[6.d[\'25\']](A)}7(!6[6.d[\'14\']]){6[6.d[\'14\']]=6.8[6.d[\'14\']]}1n(6.8.B){D\'+1\':D\'-1\':D\'32\':D\'32+\':D\'33\':D\'33+\':6.30=6.8.B;6.8.B=G;T}7(!6.8.B){7(6.8[6.d[\'F\']]==\'1a\'){6.8.B=\'1a\'}C{7(y 6[6.d[\'F\']]==\'S\'){6.8.B=1x.34(6[6.d[\'F\']]/6.8[6.d[\'F\']])}C{w h=3H(r.2m(),6,\'31\');6.8.B=1x.34(h/6.8[6.d[\'F\']]);6[6.d[\'F\']]=6.8.B*6.8[6.d[\'F\']];7(!6.30)6.1f=G}7(6.8.B==\'5j\'||6.8.B<0){P(A,\'27 a 35 S 2D B 8: 5k 4g "1".\');6.8.B=1}6.8.B=36(6.8.B,6)}}7(!6[6.d[\'F\']]){7(6.8.B!=\'1a\'&&6.8[6.d[\'F\']]!=\'1a\'){6[6.d[\'F\']]=6.8.B*6.8[6.d[\'F\']];6.1f=G}C{6[6.d[\'F\']]=\'1a\'}}7(6.8.B==\'1a\'){6.2j=A;6.3I=(6[6.d[\'F\']]==\'1a\')?3H(r.2m(),6,\'31\'):6[6.d[\'F\']];7(6.1f===G){6[6.d[\'F\']]=\'1a\'}6.8.B=2E(g,6,0)}7(y 6.W==\'1k\'){6.W=0}7(y 6.1f==\'1k\'){6.1f=(6[6.d[\'F\']]==\'1a\')?G:\'2C\'}6.8.1y=6.8.B;6.13=G;6.W=4h(6.W);7(6.1f==\'2k\')6.1f=\'1b\';7(6.1f==\'5l\')6.1f=\'2B\';1n(6.1f){D\'2C\':D\'1b\':D\'2B\':7(6[6.d[\'F\']]!=\'1a\'){w p=3a(2n(g,6),6);6.13=A;6.W[6.d[1]]=p[1];6.W[6.d[3]]=p[0]}T;2o:6.1f=G;6.13=(6.W[0]==0&&6.W[1]==0&&6.W[2]==0&&6.W[3]==0)?G:A;T}7(y 6.8.3b!=\'S\')6.8.3b=(6.2j)?1:6.8.B;7(y 6.12.8!=\'S\')6.12.8=(6.2j)?\'1a\':6.8.B;7(y 6.12.1e!=\'S\')6.12.1e=5m;6.K=2F($11,6.K,G,A);6.Q=2F($11,6.Q);6.R=2F($11,6.R);6.Y=2F($11,6.Y,A);6.K=$.1M(A,{},6.12,6.K);6.Q=$.1M(A,{},6.12,6.Q);6.R=$.1M(A,{},6.12,6.R);6.Y=$.1M(A,{},6.12,6.Y);7(y 6.Y.3c!=\'15\')6.Y.3c=G;7(y 6.Y.3J!=\'9\')6.Y.3J=$.1w.1s.4i;7(y 6.K.1g!=\'15\')6.K.1g=A;7(y 6.K.2G!=\'15\')6.K.2G=A;7(y 6.K.3K!=\'S\')6.K.3K=0;7(y 6.K.28!=\'S\')6.K.28=(6.K.1e<10)?5n:6.K.1e*5;7(6.1A){6.1A=3L(6.1A)}7(6.P){P(A,\'4j F: \'+6.F);P(A,\'4j 14: \'+6.14);P(A,\'4k 5o: \'+6.8.F);P(A,\'4k 5p: \'+6.8.14);P(A,\'3d 2D 8 B: \'+6.8.B);7(6.K.1g)P(A,\'3d 2D 8 3M 5q: \'+6.K.8);7(6.Q.X)P(A,\'3d 2D 8 3M 5r: \'+6.Q.8);7(6.R.X)P(A,\'3d 2D 8 3M 5s: \'+6.R.8)}};q.4l=9(){7(q.L(\'29\')==\'4m\'||q.L(\'29\')==\'5t\'){P(6.P,\'5u 5v-5w "29" 5x 5y "5z" 5A "4n".\')}r.L({29:\'4n\',5B:\'4o\',2H:q.L(\'2H\'),1c:q.L(\'1c\'),2l:q.L(\'2l\'),2I:q.L(\'2I\')});q.1h(\'4p\',{F:q.L(\'F\'),14:q.L(\'14\'),2H:q.L(\'2H\'),1c:q.L(\'1c\'),2l:q.L(\'2l\'),2I:q.L(\'2I\'),\'3N\':q.L(\'3N\'),29:q.L(\'29\'),2k:q.L(\'2k\'),1b:q.L(\'1b\')}).L({2H:0,1c:0,2l:0,2I:0,\'3N\':\'3O\',29:\'4m\'});7(6.13){H(q).1I(9(){w m=1R($(Z).L(6.d[\'1c\']));7(2a(m))m=0;$(Z).1h(\'1u\',m)})}};q.4q=9(){q.3P();q.U(\'1B.M\'+J,9(e){e.1d();q.E(\'1J\');6.K.1g=G;1S=\'4r\'});q.U(\'1J.M\'+J,9(e,g){e.1d();7(y g==\'15\'){P(A,\'5C a 3Q 5D 1m 1P, 1Q 2J "1B" 2b 1z.\');q.E(\'1B\');z}1S=A;7(3e!=2p)5E(3e);7(3f!=2p)4s(3f);7(3g!=2p)4s(3g);w a=6.K.28-2q,2c=2K-1x.2r(a*2K/6.K.28);7(2c!=0){7(6.K.4t)6.K.4t.18($11,2c,a)}});q.U(\'1g.M\'+J,9(e,b,c,d){e.1d();q.E(\'1J\');w v=[b,c,d],t=[\'17\',\'S\',\'15\'],a=2s(v,t);w b=a[0],c=a[1],d=a[2];7(b!=\'Q\'&&b!=\'R\')b=1N;7(y c!=\'S\')c=0;7(d)6.K.1g=A;7(!6.K.1g){e.4u();z}1S=G;w f=6.K.28-2q,4v=f+c;2c=2K-1x.2r(f*2K/6.K.28);3e=2L(9(){7(q.1m(\':2M\')){q.E(\'1g\',b)}C{2q=0;q.E(b,6.K)}},4v);7(6.K.2t===\'5F\'){3f=5G(9(){2q+=50},50)}7(6.K.4w&&2c==0){6.K.4w.18($11,2c,f)}7(6.K.4x){3g=2L(9(){6.K.4x.18($11,2c,f)},c)}});q.U(\'Q.M R.M\'+J,9(e,b,c,f){e.1d();7(1S==\'4r\'||q.1m(\':4o\')){z}w v=[b,c,f],t=[\'1l\',\'S\',\'9\'],a=2s(v,t);w b=a[0],c=a[1],f=a[2];7(y b!=\'1l\')b=6[e.2d];7(y f==\'9\')b.2N=f;7(y a[1]!=\'S\'){7(y b.8==\'S\')c=b.8;C 7(y 6[e.2d].8==\'S\')c=6[e.2d].8;C c=6.8.B}7(q.1m(\':2M\')){7(b.1i)q.E(\'1i\',[e.2d,[b,c,f]]);z}7(6.8.3b>=I){P(6.P,\'27 4y 8: 4z 3R.\');z}2q=0;7(y c!=\'S\')z P(6.P,\'27 a 35 S: \'+c+\'. 27 3R\');7(b.3S&&!b.3S.18($11))z P(6.P,\'5H "3S" 5I G.\');q.E(\'4A\'+e.2d,[b,c]);7(6.1A){w s=6.1A;2e=c;1t(w j=0,l=s.V;j<l;j++){w d=e.2d;7(!s[j][1])a[0]=s[j][0].4B(\'1T\',e.2d);7(!s[j][2])d=(d==\'Q\')?\'R\':\'Q\';a[1]=2e+s[j][3];s[j][0].E(\'4A\'+d,a)}}});q.U(\'3T.M\'+J,9(e,d,f){e.1d();7(6.2j){2e=f;6.8.1y=6.8.B;w g=H(q);7(6.13)1o(g,6);6.8.B=4C(g,6,2e);f=6.8.B-6.8.1y+2e;7(f<=0){6.8.B=2E(g,6,I-2e);f=2e}7(6.13)1o(g,6,A)}7(!6.1U){w h=I-N;7(h-f<0){f=h}7(N==0){f=0}}N+=f;7(N>=I)N-=I;7(!6.1U){7(N==0&&f!=0&&d.3h)d.3h.18($11);7(6.3i){7(f==0){q.E(\'R\',I-6.8.B);z}}C 2f(6,N)}7(f==0){e.4u();z}H(q).16(I-f).5J(q);7(I<6.8.B+f){H(q).16(0,(6.8.B+f)-I).3j(A).2O(q)}w g=H(q),1C=4D(g,6,f),1q=4E(g,6),2g=g.1D(f-1),1E=1C.2h(),1V=1q.2h();7(6.13){1o(1E,6);1o(1q,6)}7(6.1f)w p=3a(1q,6);7(d.1r==\'4F\'&&6.8.1y<f){w i=g.16(6.8.1y,f).2P(),3k=6.8[6.d[\'F\']];6.8[6.d[\'F\']]=\'1a\'}C{w i=G}w j=2u(g.16(0,f),6,\'F\'),1F=3l(1W(1q,6,A),6,!6.13);7(i){6.8[6.d[\'F\']]=3k}7(6.13){1o(1E,6,6.W[6.d[1]]);1o(2g,6,6.W[6.d[3]])}7(6.1f){6.W[6.d[1]]=p[1];6.W[6.d[3]]=p[0]}w k={},3U={},2v={},2w={},O=d.1e;7(d.1r==\'3O\')O=0;C 7(O==\'K\')O=6.12.1e/6.12.8*f;C 7(O<=0)O=0;C 7(O<10)O=j/O;w l={1e:O,1j:d.1j};7(d.3m)d.3m.18($11,1C,1q,1F,O);7(6.13){w m=6.W[6.d[3]];2v[6.d[\'1c\']]=2g.1h(\'1u\');3U[6.d[\'1c\']]=1V.1h(\'1u\')+6.W[6.d[1]];2w[6.d[\'1c\']]=1E.1h(\'1u\');2g.1B().1v(2v,l);1V.1B().1v(3U,l);1E.1B().1v(2w,l)}C{w m=0}k[6.d[\'1b\']]=m;7(6[6.d[\'F\']]==\'1a\'||6[6.d[\'14\']]==\'1a\'){r.1B().1v(1F,l)}1n(d.1r){D\'1X\':D\'1Y\':D\'1G\':w n=q.3j().2O(r);T}1n(d.1r){D\'1G\':H(n).16(0,f).1p();D\'1X\':D\'1Y\':H(n).16(6.8.B).1p();T}1n(d.1r){D\'2x\':1K(d,q,0,O);T;D\'1X\':n.L({3n:0});1K(d,n,1,O);1K(d,q,1,O,9(){n.1p()});T;D\'1Y\':3V(d,q,n,6,O,A);T;D\'1G\':3W(d,q,n,6,O,A,f);T}1n(d.1r){D\'2x\':D\'1X\':D\'1Y\':D\'1G\':3o=O;O=0;T}w o=f;q.L(6.d[\'1b\'],-j);q.1v(k,{1e:O,1j:d.1j,2Q:9(){w a=6.8.B+o-I;7(a>0){H(q).16(I).1p();1C=H(q).16(I-(o-a)).4G().5K(H(q).16(0,a).4G())}7(i)i.3p();7(6.13){w b=H(q).1D(6.8.B+o-1);b.L(6.d[\'1c\'],b.1h(\'1u\'))}w c=9(){7(d.2N){d.2N.18($11,1C,1q,1F)}7(1i.V){2L(9(){q.E(1i[0][0],1i[0][1]);1i.4H()},1)}};1n(d.1r){D\'2x\':D\'1G\':1K(d,q,1,3o,c);T;2o:c();T}}});q.E(\'2y\',[G,1F]).E(\'1g\',O)});q.U(\'3X.M\'+J,9(e,f,g){e.1d();7(6.2j){6.8.1y=6.8.B;w h=H(q);7(6.13)1o(h,6);6.8.B=2E(h,6,g);7(6.8.1y-g>=6.8.B)6.8.B=2E(h,6,++g);7(6.13)1o(h,6,A)}7(!6.1U){7(N==0){7(g>I-6.8.B){g=I-6.8.B}}C{7(N-g<6.8.B){g=N-6.8.B}}}N-=g;7(N<0)N+=I;7(!6.1U){7(N==6.8.B&&g!=0&&f.3h)f.3h.18($11);7(6.3i){7(g==0){q.E(\'Q\',I-6.8.B);z}}C 2f(6,N)}7(g==0)z;7(I<6.8.B+g)H(q).16(0,(6.8.B+g)-I).3j(A).2O(q);w h=H(q),1C=3Y(h,6),1q=3Z(h,6,g),2g=1C.1D(g-1),1E=1C.2h(),1V=1q.2h();7(6.13){1o(1E,6);1o(1V,6)}7(6.1f)w p=3a(1q,6);7(f.1r==\'4F\'&&6.8.1y<g){w i=h.16(6.8.1y,g).2P(),3k=6.8[6.d[\'F\']];6.8[6.d[\'F\']]=\'1a\'}C{w i=G}w j=2u(h.16(0,g),6,\'F\'),1F=3l(1W(1q,6,A),6,!6.13);7(i){6.8[6.d[\'F\']]=3k}7(6.13){1o(1E,6,6.W[6.d[1]]);1o(1V,6,6.W[6.d[1]])}7(6.1f){6.W[6.d[1]]=p[1];6.W[6.d[3]]=p[0]}w k={},2w={},2v={},O=f.1e;7(f.1r==\'3O\')O=0;C 7(O==\'K\')O=6.12.1e/6.12.8*g;C 7(O<=0)O=0;C 7(O<10)O=j/O;w l={1e:O,1j:f.1j};7(f.3m)f.3m.18($11,1C,1q,1F,O);7(6.13){2w[6.d[\'1c\']]=1E.1h(\'1u\');2v[6.d[\'1c\']]=2g.1h(\'1u\')+6.W[6.d[3]];1V.L(6.d[\'1c\'],1V.1h(\'1u\')+6.W[6.d[1]]);1E.1B().1v(2w,l);2g.1B().1v(2v,l)}k[6.d[\'1b\']]=-j;7(6[6.d[\'F\']]==\'1a\'||6[6.d[\'14\']]==\'1a\'){r.1B().1v(1F,l)}1n(f.1r){D\'1X\':D\'1Y\':D\'1G\':w m=q.3j().2O(r);T}1n(f.1r){D\'1X\':D\'1Y\':H(m).16(0,g).1p();H(m).16(6.8.B).1p();T;D\'1G\':H(m).16(6.8.1y).1p();T}1n(f.1r){D\'2x\':1K(f,q,0,O);T;D\'1X\':m.L({3n:0});1K(f,m,1,O);1K(f,q,1,O,9(){m.1p()});T;D\'1Y\':3V(f,q,m,6,O,G);T;D\'1G\':3W(f,q,m,6,O,G,g);T}1n(f.1r){D\'2x\':D\'1X\':D\'1Y\':D\'1G\':3o=O;O=0;T}w n=g;q.1v(k,{1e:O,1j:f.1j,2Q:9(){w a=6.8.B+n-I,4I=(6.13)?6.W[6.d[3]]:0;q.L(6.d[\'1b\'],4I);7(a>0){H(q).16(I).1p()}w b=H(q).16(0,n).2O(q).2h();7(a>0){1q=2n(H(q),6)}7(i)i.3p();7(6.13){7(I<6.8.B+n){w c=H(q).1D(6.8.B-1);c.L(6.d[\'1c\'],c.1h(\'1u\')+6.W[6.d[3]])}b.L(6.d[\'1c\'],b.1h(\'1u\'))}w d=9(){7(f.2N){f.2N.18($11,1C,1q,1F)}7(1i.V){2L(9(){q.E(1i[0][0],1i[0][1]);1i.4H()},1)}};1n(f.1r){D\'2x\':D\'1G\':1K(f,q,1,3o,d);T;2o:d();T}}});q.E(\'2y\',[G,1F]).E(\'1g\',O)});q.U(\'2i.M\'+J,9(e,b,c,d,f,g){e.1d();7(q.1m(\':2M\'))z;w v=[b,c,d,f,g],t=[\'17/S/1l\',\'S\',\'15\',\'1l\',\'17\'],a=2s(v,t);w f=a[3],g=a[4];b=2R(a[0],a[1],a[2],N,I,q);7(b==0)z;7(y f!=\'1l\')f=G;7(g!=\'Q\'&&g!=\'R\'){7(6.1U){7(b<=I/2)g=\'R\';C g=\'Q\'}C{7(N==0||N>b)g=\'R\';C g=\'Q\'}}7(g==\'Q\')q.E(\'Q\',[f,I-b]);C q.E(\'R\',[f,b])});q.U(\'1A.M\'+J,9(e,s){7(s)s=3L(s);C 7(6.1A)s=6.1A;C z P(6.P,\'4c 3Q 4g 1A.\');w n=q.4B(\'3q\');1t(w j=0,l=s.V;j<l;j++){s[j][0].E(\'2i\',[n,s[j][3],A])}});q.U(\'1i.M\'+J,9(e,a,b){7(y a==\'1k\'){z 1i}C 7(y a==\'9\'){a.18($11,1i)}C 7(2S(a)){1i=a}C{1i.5L([a,b])}});q.U(\'5M.M\'+J,9(e,b,c,d,f){e.1d();w v=[b,c,d,f],t=[\'17/1l\',\'17/S/1l\',\'15\',\'S\'],a=2s(v,t);w b=a[0],c=a[1],d=a[2],f=a[3];7(y b==\'1l\'&&y b.2T==\'1k\')b=$(b);7(y b==\'17\')b=$(b);7(y b!=\'1l\'||y b.2T==\'1k\'||b.V==0)z P(6.P,\'27 a 35 1l.\');7(y c==\'1k\')c=\'3r\';7(6.13){b.1I(9(){w m=1R($(Z).L(6.d[\'1c\']));7(2a(m))m=0;$(Z).1h(\'1u\',m)})}w g=c,2U=\'2U\';7(c==\'3r\'){7(d){7(N==0){c=I-1;2U=\'4J\'}C{c=N;N+=b.V}7(c<0)c=0}C{c=I-1;2U=\'4J\'}}C{c=2R(c,f,d,N,I,q)}7(g!=\'3r\'&&!d){7(c<N)N+=b.V}7(N>=I)N-=I;w h=H(q).1D(c);7(h.V){h[2U](b)}C{q.4K(b)}I=H(q).V;q.E(\'2V\');w i=2W(q,6);2X(6,I);2f(6,N);q.E(\'2y\',[A,i])});q.U(\'5N.M\'+J,9(e,b,c,d){e.1d();w v=[b,c,d],t=[\'17/S/1l\',\'15\',\'S\'],a=2s(v,t);w b=a[0],c=a[1],d=a[2];7(y b==\'1k\'||b==\'3r\'){H(q).2h().1p()}C{b=2R(b,d,c,N,I,q);w f=H(q).1D(b);7(f.V){7(b<N)N-=f.V;f.1p()}}I=H(q).V;w g=2W(q,6);2X(6,I);2f(6,N);q.E(\'2y\',[A,g])});q.U(\'3q.M\'+J,9(e,a){e.1d();7(N==0)w b=0;C w b=I-N;7(y a==\'9\')a.18($11,b);z b});q.U(\'4L.M\'+J,9(e,a){e.1d();w b=1x.2r(I/6.8.B-1);7(N==0)w c=0;C 7(N<I%6.8.B)w c=0;C 7(N==6.8.B&&!6.1U)w c=b;C w c=1x.5O((I-N)/6.8.B);7(c<0)c=0;7(c>b)c=b;7(y a==\'9\')a.18($11,c);z c});q.U(\'5P.M\'+J,9(e,a){e.1d();$i=2n(H(q),6);7(y a==\'9\')a.18($11,$i);z $i});q.U(\'1S.M\'+J,9(e,a){e.1d();7(y a==\'9\')a.18($11,1S);z 1S});q.U(\'1T.M\'+J,9(e,a,b,c){e.1d();w d=G;7(y a==\'9\'){a.18($11,6)}C 7(y a==\'1l\'){24=$.1M(A,{},24,a);7(b!==G)d=A;C 6=$.1M(A,{},6,a)}C 7(y a!=\'1k\'){7(y b==\'9\'){w f=3s(\'6.\'+a);7(y f==\'1k\')f=\'\';b.18($11,f)}C 7(y b!=\'1k\'){7(y c!==\'15\')c=A;7(q.1m(\':2M\')){2L(9(){q.E(\'1T\',[a,b,c])},2K);z P(6.P,\'3Q 2M, 1T 5Q.\')}3s(\'24.\'+a+\' = b\');7(c!==G)d=A;C 3s(\'6.\'+a+\' = b\')}C{z 3s(\'6.\'+a)}}7(d){1o(H(q),6);q.3C(24);2W(q,6)}z 6});q.U(\'2V.M\'+J,9(e,a,b){e.1d();7(y a==\'1k\'||a.V==0)a=$(\'5R\');C 7(y a==\'17\')a=$(a);7(y a!=\'1l\')z P(6.P,\'27 a 35 1l.\');7(y b!=\'17\'||b.V==0)b=\'a.4M\';a.5S(b).1I(9(){w h=Z.4N||\'\';7(h.V>0&&H(q).4O($(h))!=-1){$(Z).1Z(\'20\').20(9(e){e.1L();q.E(\'2i\',h)})}})});q.U(\'2y.M\'+J,9(e,b,c){e.1d();7(!6.Y.19)z;7(y b==\'15\'&&b){H(6.Y.19).1p();1t(w a=0,l=1x.2r(I/6.8.B);a<l;a++){w i=H(q).1D(2R(a*6.8.B,0,A,N,I,q));6.Y.19.4K(6.Y.3J(a+1,i))}H(6.Y.19).1Z(\'20\').1I(9(a){$(Z).20(9(e){e.1L();q.E(\'2i\',[a*6.8.B,0,A,6.Y])})})}q.E(\'4L\',9(a){H(6.Y.19).2Y(\'4P\').1D(a).3t(\'4P\')})});q.U(\'2z.M\'+J,9(e,a){e.1d();7(a){q.E(\'2i\',[0,0,A,{1e:0}])}7(6.13){1o(H(q),6)}q.E(\'1J\').L(q.1h(\'4p\'));q.3P();q.41();r.5T(q)});q.U(\'4Q.M\'+J,9(e,a,b){e.1d();P(A,\'26 2b 1z "4Q" 1m 1P, 1Q "3T".\');q.E(\'3T\',[a,b])});q.U(\'4R.M\'+J,9(e,a,b){e.1d();P(A,\'26 2b 1z "4R" 1m 1P, 1Q "3X".\');q.E(\'3X\',[a,b])})};q.3P=9(){q.1Z(\'.M\'+J)};q.4S=9(){q.41();2X(6,I);2f(6,N);7(6.K.2t){r.U(\'3u.M\'+J,9(){q.E(\'1J\')});r.U(\'3v.M\'+J,9(){q.E(\'1g\')})}7(6.Q.X){6.Q.X.U(\'20.M\'+J,9(e){e.1L();q.E(\'Q\')});7(6.Q.2t){6.Q.X.U(\'3u.M\'+J,9(){q.E(\'1J\')});6.Q.X.U(\'3v.M\'+J,9(){q.E(\'1g\')})}}7(6.R.X){6.R.X.U(\'20.M\'+J,9(e){e.1L();q.E(\'R\')});7(6.R.2t){6.R.X.U(\'3u.M\'+J,9(){q.E(\'1J\')});6.R.X.U(\'3v.M\'+J,9(){q.E(\'1g\')})}}7($.1w.1H){7(6.Q.1H){r.1H(9(e,a){7(a>0){e.1L();3w=(y 6.Q.1H==\'S\')?6.Q.1H:\'\';q.E(\'Q\',3w)}})}7(6.R.1H){r.1H(9(e,a){7(a<0){e.1L();3w=(y 6.R.1H==\'S\')?6.R.1H:\'\';q.E(\'R\',3w)}})}}7(6.Y.19){7(6.Y.2t){6.Y.19.U(\'3u.M\'+J,9(){q.E(\'1J\')});6.Y.19.U(\'3v.M\'+J,9(){q.E(\'1g\')})}}7(6.R.21||6.Q.21){$(42).U(\'4T.M\'+J,9(e){w k=e.4U;7(k==6.R.21){e.1L();q.E(\'R\')}7(k==6.Q.21){e.1L();q.E(\'Q\')}})}7(6.Y.3c){$(42).U(\'4T.M\'+J,9(e){w k=e.4U;7(k>=49&&k<58){k=(k-49)*6.8.B;7(k<=I){e.1L();q.E(\'2i\',[k,0,A,6.Y])}}})}7(6.K.1g){q.E(\'1g\',6.K.3K);7($.1w.2G&&6.K.2G){q.2G(\'1J\',\'1g\')}}};q.41=9(){$(42).1Z(\'.M\'+J);r.1Z(\'.M\'+J);7(6.Q.X)6.Q.X.1Z(\'.M\'+J);7(6.R.X)6.R.X.1Z(\'.M\'+J);7(6.Y.19)6.Y.19.1Z(\'.M\'+J);2X(6,\'2P\');2f(6,\'2Y\');7(6.Y.19){H(6.Y.19).1p()}};q.1T=9(a,b){P(A,\'26 "1T" 3x 3y 1m 1P, 1Q 2J "1T" 2b 1z.\');w c=G;w d=9(a){c=a};7(!a)a=d;7(!b)b=d;q.E(\'1T\',[a,b]);z c};q.4V=9(){P(A,\'26 "4V" 3x 3y 1m 1P, 1Q 2J "3q" 2b 1z.\');w b=G;q.E(\'3q\',9(a){b=a});z b};q.2z=9(){P(A,\'26 "2z" 3x 3y 1m 1P, 1Q 2J "2z" 2b 1z.\');q.E(\'2z\');z q};q.4W=9(a,b){P(A,\'26 "4W" 3x 3y 1m 1P, 1Q 2J "2V" 2b 1z.\');q.E(\'2V\',[a,b]);z q};7(q.2m().1m(\'.4X\')){w r=q.2m();q.E(\'2z\')}w r=q.5U(\'<5V 5W="4X" />\').2m(),6={},24=o,I=H(q).V,N=0,3e=2p,3f=2p,3g=2p,2q=0,1S=A,1N=\'R\',1i=[],J=$.1w.1s.J++;q.3C(24,A);q.4l();q.4q();q.4S();7(6.8.22!==0&&6.8.22!==G){w s=6.8.22;7(s===A){s=3z.5X.4N;7(!s.V)s=0}C 7(s===\'4Y\'){s=1x.34(1x.4Y()*I)}q.E(\'2i\',[s,0,A,{1e:0}])}w u=2W(q,6,G),4Z=2n(H(q),6);7(6.51){6.51.18($11,4Z,u)}q.E(\'2y\',[A,u]);q.E(\'2V\');z Z};$.1w.1s.J=0;$.1w.1s.3D={P:G,1A:G,3i:A,1U:A,1N:\'1b\',8:{22:0},12:{1j:\'5Y\',2t:G,1H:G,1i:G}};$.1w.1s.4i=9(a,b){z\'<a 5Z="#"><52>\'+a+\'</52></a>\'};9 1K(a,c,x,d,f){w o={1e:d,1j:a.1j};7(y f==\'9\')o.2Q=f;c.1v({3n:x},o)}9 3V(a,b,c,o,d,e){w f=1W(3Y(H(b),o),o,A)[0],43=1W(H(c),o,A)[0],3A=(e)?-43:f,23={},2A={};23[o.d[\'F\']]=43;23[o.d[\'1b\']]=3A;2A[o.d[\'1b\']]=0;b.1v({3n:\'+=0\'},d);c.L(23).1v(2A,{1e:d,1j:a.1j,2Q:9(){$(Z).1p()}})}9 3W(a,b,c,o,d,e,n){w f=1W(3Z(H(b),o,n),o,A)[0],44=1W(H(c),o,A)[0],3A=(e)?-44:f,23={},2A={};23[o.d[\'F\']]=44;23[o.d[\'1b\']]=0;2A[o.d[\'1b\']]=3A;c.L(23).1v(2A,{1e:d,1j:a.1j,2Q:9(){$(Z).1p()}})}9 2X(o,t){7(t==\'3p\'||t==\'2P\'){w f=t}C 7(o.8.3b>=t){P(o.P,\'27 4y 8: 4z 3R\');w f=\'2P\'}C{w f=\'3p\'}7(o.Q.X)o.Q.X[f]();7(o.R.X)o.R.X[f]();7(o.Y.19)o.Y.19[f]()}9 2f(o,f){7(o.1U||o.3i)z;w a=(f==\'2Y\'||f==\'3t\')?f:G;7(o.R.X){w b=a||(f==o.8.B)?\'3t\':\'2Y\';o.R.X[b](\'53\')}7(o.Q.X){w b=a||(f==0)?\'3t\':\'2Y\';o.Q.X[b](\'53\')}}9 2s(c,d){w e=[];1t(w a=0,54=c.V;a<54;a++){1t(w b=0,55=d.V;b<55;b++){7(d[b].3B(y c[a])>-1&&!e[b]){e[b]=c[a];T}}}z e}9 3L(s){7(!2S(s))s=[[s]];7(!2S(s[0]))s=[s];1t(w j=0,l=s.V;j<l;j++){7(y s[j][0]==\'17\')s[j][0]=$(s[j][0]);7(y s[j][1]!=\'15\')s[j][1]=A;7(y s[j][2]!=\'15\')s[j][2]=A;7(y s[j][3]!=\'S\')s[j][3]=0}z s}9 45(k){7(k==\'2B\')z 39;7(k==\'1b\')z 37;7(k==\'4d\')z 38;7(k==\'60\')z 40;z-1}9 2Z(a,b){7(y b==\'9\')b=b.18(a);7(y b==\'1k\')b={};z b}9 2F(a,b,c,d){7(y c!=\'15\')c=G;7(y d!=\'15\')d=G;b=2Z(a,b);7(y b==\'17\'){w e=45(b);7(e==-1)b=$(b);C b=e}7(c){7(y b==\'15\')b={3c:b};7(y b.2T!=\'1k\')b={19:b};7(y b.19==\'9\')b.19=b.19.18(a);7(y b.19==\'17\')b.19=$(b.19);7(y b.1z!=\'17\')b.1z=\'20\'}C 7(d){7(y b==\'15\')b={1g:b};7(y b==\'S\')b={28:b}}C{7(y b.2T!=\'1k\')b={X:b};7(y b==\'S\')b={21:b};7(y b.X==\'9\')b.X=b.X.18(a);7(y b.X==\'17\')b.X=$(b.X);7(y b.21==\'17\')b.21=45(b.21);7(y b.1z!=\'17\')b.1z=\'20\'}z b}9 2R(a,b,c,d,e,f){7(y a==\'17\'){7(2a(a))a=$(a);C a=1R(a)}7(y a==\'1l\'){7(y a.2T==\'1k\')a=$(a);a=H(f).4O(a);7(a==-1)a=0;7(y c!=\'15\')c=G}C{7(y c!=\'15\')c=A}7(2a(a))a=0;C a=1R(a);7(2a(b))b=0;C b=1R(b);7(c){a+=d}a+=b;7(e>0){56(a>=e){a-=e}56(a<0){a+=e}}z a}9 H(c,f){w a=$(\'> *\',c);7(y f==\'17\')a=a.61(f);z a}9 2n(i,o){z i.16(0,o.8.B)}9 4D(i,o,n){z i.16(n,o.8.1y+n)}9 4E(i,o){z i.16(0,o.8.B)}9 3Y(i,o){z i.16(0,o.8.1y)}9 3Z(i,o,n){z i.16(n,o.8.B+n)}9 1o(i,o,m){w x=(y m==\'15\')?m:G;7(y m!=\'S\')m=0;i.1I(9(){w t=1R($(Z).L(o.d[\'1c\']));7(2a(t))t=0;$(Z).1h(\'57\',t);$(Z).L(o.d[\'1c\'],((x)?$(Z).1h(\'57\'):m+$(Z).1h(\'1u\')))})}9 1W(i,o,a){59=2u(i,o,\'F\',a);5a=46(i,o,\'14\',a);z[59,5a]}9 46(i,o,a,b){7(y b!=\'15\')b=G;7(y o[o.d[a]]==\'S\'&&b)z o[o.d[a]];7(y o.8[o.d[a]]==\'S\')z o.8[o.d[a]];w c=(a.47().3B(\'F\')>-1)?\'1O\':\'25\';z 3F(i,o,c)}9 3F(i,o,a){w s=0;i.1I(9(){w m=$(Z)[o.d[a]](A);7(s<m)s=m});z s}9 3H(b,o,c){w d=b[o.d[c]](),48=(o.d[c].47().3B(\'F\')>-1)?[\'62\',\'63\']:[\'64\',\'65\'];1t(a=0,l=48.V;a<l;a++){w m=1R(b.L(48[a]));7(2a(m))m=0;d-=m}z d}9 2u(i,o,a,b){7(y b!=\'15\')b=G;7(y o[o.d[a]]==\'S\'&&b)z o[o.d[a]];7(y o.8[o.d[a]]==\'S\')z o.8[o.d[a]]*i.V;w c=(a.47().3B(\'F\')>-1)?\'1O\':\'25\';z 5b(i,o,c)}9 5b(i,o,a){w s=0;i.1I(9(){w j=$(Z);7(j.1m(\':B\')){s+=j[o.d[a]](A)}});z s}9 3G(i,o,a){w s=G,v=G;i.1I(9(){c=$(Z)[o.d[a]](A);7(s===G)s=c;C 7(s!=c)v=A});z v}9 3l(a,o,p){7(y p!=\'15\')p=A;w b=(o.13&&p)?o.W:[0,0,0,0];w c={};c[o.d[\'F\']]=a[0]+b[1]+b[3];c[o.d[\'14\']]=a[1]+b[0]+b[2];z c}9 2W(a,o,p){w b=a.2m(),$i=H(a),$v=2n($i,o),4a=3l(1W($v,o,A),o,p);b.L(4a);7(o.13){w c=$v.2h();c.L(o.d[\'1c\'],c.1h(\'1u\')+o.W[o.d[1]]);a.L(o.d[\'2k\'],o.W[o.d[0]]);a.L(o.d[\'1b\'],o.W[o.d[3]])}a.L(o.d[\'F\'],2u($i,o,\'F\')*2);a.L(o.d[\'14\'],46($i,o,\'14\'));z 4a}9 4h(p){7(y p==\'1k\')z[0,0,0,0];7(y p==\'S\')z[p,p,p,p];C 7(y p==\'17\')p=p.5c(\'66\').67(\'\').5c(\' \');7(!2S(p)){z[0,0,0,0]}1t(w i=0;i<4;i++){p[i]=1R(p[i])}1n(p.V){D 0:z[0,0,0,0];D 1:z[p[0],p[0],p[0],p[0]];D 2:z[p[0],p[1],p[0],p[1]];D 3:z[p[0],p[1],p[2],p[1]];2o:z[p[0],p[1],p[2],p[3]]}}9 3a(a,o){w x=(y o[o.d[\'F\']]==\'S\')?1x.2r(o[o.d[\'F\']]-2u(a,o,\'F\')):0;1n(o.1f){D\'1b\':z[0,x];T;D\'2B\':z[x,0];T;D\'2C\':2o:w b=1x.2r(x/2),5d=1x.34(x/2);z[b,5d];T}}9 4C(b,o,c){w d=0,22=o.8.B-c-1,x=0;7(22<0)22=b.V-1;1t(w a=22;a>=0;a--){d+=b.1D(a)[o.d[\'1O\']](A);7(d>o.3I)z 36(x,o);7(a==0)a=b.V;x++}}9 2E(b,o,c){w d=0,x=0;1t(w a=c,l=b.V-1;a<=l;a++){d+=b.1D(a)[o.d[\'1O\']](A);7(d>o.3I)z 36(x,o);7(a==b.V-1)a=-1;x++}}9 36(x,o){1n(o.30){D\'+1\':z x+1;T;D\'-1\':z x-1;T;D\'32\':7(x%2==0)z x-1;T;D\'32+\':7(x%2==0)z x+1;T;D\'33\':7(x%2==1)z x-1;T;D\'33+\':7(x%2==1)z x+1;T;2o:z x;T}}9 2S(a){z y(a)==\'1l\'&&(a 68 69)}9 P(d,m){7(!d)z G;7(y m==\'17\')m=\'1s: \'+m;C m=[\'1s:\',m];7(3z.4b&&3z.4b.5e)3z.4b.5e(m);z G}$.1w.4M=9(o){z Z.1s(o)}})(6a);',62,383,'||||||opts|if|items|function|||||||||||||||||||||||var||typeof|return|true|visible|else|case|trigger|width|false|getItems|totalItems|serial|auto|css|cfs|firstItem|a_dur|debug|prev|next|number|break|bind|length|padding|button|pagination|this||tt0|scroll|usePadding|height|boolean|slice|string|call|container|variable|left|marginRight|stopPropagation|duration|align|play|data|queue|easing|undefined|object|is|switch|resetMargin|remove|c_new|fx|carouFredSel|for|cfs_origCssMargin|animate|fn|Math|oldVisible|event|synchronise|stop|c_old|eq|l_old|w_siz|uncover|mousewheel|each|pause|fx_fade|preventDefault|extend|direction|outerWidth|deprecated|use|parseInt|isPaused|configuration|circular|l_new|getSizes|crossfade|cover|unbind|click|key|start|css_o|opts_orig|outerHeight|The|Not|pauseDuration|position|isNaN|custom|perc|type|oI|enableNavi|l_cur|last|slideTo|variableVisible|top|marginBottom|parent|getCurrentItems|default|null|pauseTimePassed|ceil|sortParams|pauseOnHover|getTotalSize|a_cur|a_old|fade|updatePageStatus|destroy|ani_o|right|center|of|getVisibleItemsNext|getNaviObject|nap|marginTop|marginLeft|the|100|setTimeout|animated|onAfter|appendTo|hide|complete|getItemIndex|is_array|jquery|before|linkAnchors|setSizes|showNavi|removeClass|getObject|visibleAdjust|innerWidth|odd|even|floor|valid|getVisibleItemsAdjust||||getAlignPadding|minimum|keys|Number|autoTimeout|autoInterval|timerInterval|onEnd|infinite|clone|orgW|mapWrapperSizes|onBefore|opacity|f_dur|show|currentPosition|end|eval|addClass|mouseenter|mouseleave|num|public|method|window|cur_l|indexOf|init|defaults|lrgst_b|getTrueLargestSize|hasVariableSizes|getTrueInnerSize|maxDimention|anchorBuilder|delay|getSynchArr|scrolled|float|none|unbind_events|carousel|scrolling|conditions|slide_prev|a_new|fx_cover|fx_uncover|slide_next|getOldItemsNext|getNewItemsNext||unbind_buttons|document|new_w|old_w|getKeyCode|getLargestSize|toLowerCase|arr||sz|console|No|up|innerHeight|dx|to|getPadding|pageAnchorBuilder|Carousel|Item|build|absolute|relative|hidden|cfs_origCss|bind_events|stopped|clearInterval|onPausePause|stopImmediatePropagation|dur2|onPauseEnd|onPauseStart|enough|not|slide_|triggerHandler|getVisibleItemsPrev|getOldItemsPrev|getNewItemsPrev|directscroll|get|shift|new_m|after|append|currentPage|caroufredsel|hash|index|selected|slidePrev|slideNext|bind_buttons|keyup|keyCode|current_position|link_anchors|caroufredsel_wrapper|random|itm||onCreate|span|disabled|l1|l2|while|cfs_tempCssMargin||s1|s2|getTotalSizeVariable|split|x2|log|element|found|selector|option|Infinity|Set|bottom|500|2500|widths|heights|automatically|backward|forward|fixed|Carousels|CSS|attribute|should|be|static|or|overflow|Pause|globally|clearTimeout|resume|setInterval|Callback|returned|prependTo|concat|push|insertItem|removeItem|round|currentVisible|timeout|body|find|replaceWith|wrap|div|class|location|swing|href|down|filter|paddingLeft|paddingRight|paddingTop|paddingBottom|px|join|instanceof|Array|jQuery'.split('|'),0,{}))
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
jQuery.fn.extend({
/**
* Returns get parameters.
*
* If the desired param does not exist, null will be returned
*
* To get the document params:
* @example value = $(document).getUrlParam("paramName");
* 
* To get the params of a html-attribut (uses src attribute)
* @example value = $('#imgLink').getUrlParam("paramName");
*/ 
 getUrlParam: function(strParamName){
	  strParamName = escape(unescape(strParamName));
	  
	  var returnVal = new Array();
	  var qString = null;
	  
	  if ($(this).attr("nodeName")=="#document") {
	  	//document-handler
		
		if (window.location.search.search(strParamName) > -1 ){
			
			qString = window.location.search.substr(1,window.location.search.length).split("&");
		}
			
	  } else if ($(this).attr("src")!="undefined") {
	  	
	  	var strHref = $(this).attr("src")
	  	if ( strHref.indexOf("?") > -1 ){
	    	var strQueryString = strHref.substr(strHref.indexOf("?")+1);
	  		qString = strQueryString.split("&");
	  	}
	  } else if ($(this).attr("href")!="undefined") {
	  	
	  	var strHref = $(this).attr("href")
	  	if ( strHref.indexOf("?") > -1 ){
	    	var strQueryString = strHref.substr(strHref.indexOf("?")+1);
	  		qString = strQueryString.split("&");
	  	}
	  } else {
	  	return null;
	  }
	  	
	  
	  if (qString==null) return null;
	  
	  
	  for (var i=0;i<qString.length; i++){
			if (escape(unescape(qString[i].split("=")[0])) == strParamName){
				returnVal.push(qString[i].split("=")[1]);
			}
			
	  }
	  
	  
	  if (returnVal.length==0) return null;
	  else if (returnVal.length==1) return returnVal[0];
	  else return returnVal;
	}
});
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


(function($) {

    $.fn.innerfade = function(options) {
        return this.each(function() {   
            $.innerfade(this, options);
        });
    };

    $.innerfade = function(container, options) {
        var settings = {
        		'animationtype':    'fade',
            'speed':            'normal',
            'type':             'sequence',
            'timeout':          2000,
            'containerheight':  'auto',
            'runningclass':     'innerfade',
            'children':         null
        };
        if (options)
            $.extend(settings, options);
        if (settings.children === null)
            var elements = $(container).children();
        else
            var elements = $(container).children(settings.children);
        if (elements.length > 1) {
            $(container).css('position', 'relative').css('height', settings.containerheight).addClass(settings.runningclass);
            for (var i = 0; i < elements.length; i++) {
                $(elements[i]).css('z-index', String(elements.length-i)).css('position', 'absolute').hide();
            };
            if (settings.type == "sequence") {
                setTimeout(function() {
                    $.innerfade.next(elements, settings, 1, 0);
                }, settings.timeout);
                $(elements[0]).show();
            } else if (settings.type == "random") {
            		var last = Math.floor ( Math.random () * ( elements.length ) );
                setTimeout(function() {
                    do { 
												current = Math.floor ( Math.random ( ) * ( elements.length ) );
										} while (last == current );             
										$.innerfade.next(elements, settings, current, last);
                }, settings.timeout);
                $(elements[last]).show();
						} else if ( settings.type == 'random_start' ) {
								settings.type = 'sequence';
								var current = Math.floor ( Math.random () * ( elements.length ) );
								setTimeout(function(){
									$.innerfade.next(elements, settings, (current + 1) %  elements.length, current);
								}, settings.timeout);
								$(elements[current]).show();
						}	else {
							alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
						}
				}
    };

    $.innerfade.next = function(elements, settings, current, last) {
        if (settings.animationtype == 'slide') {
            $(elements[last]).slideUp(settings.speed);
            $(elements[current]).slideDown(settings.speed);
        } else if (settings.animationtype == 'fade') {
            $(elements[last]).fadeOut(settings.speed);
            $(elements[current]).fadeIn(settings.speed, function() {
							removeFilter($(this)[0]);
						});
        } else
            alert('Innerfade-animationtype must either be \'slide\' or \'fade\'');
        if (settings.type == "sequence") {
            if ((current + 1) < elements.length) {
                current = current + 1;
                last = current - 1;
            } else {
                current = 0;
                last = elements.length - 1;
            }
        } else if (settings.type == "random") {
            last = current;
            while (current == last)
                current = Math.floor(Math.random() * elements.length);
        } else
            alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
        setTimeout((function() {
            $.innerfade.next(elements, settings, current, last);
        }), settings.timeout);
    };

})(jQuery);

// **** remove Opacity-Filter in ie ****
function removeFilter(element) {
	if(element.style.removeAttribute){
		element.style.removeAttribute('filter');
	}
}

(function(c){c.fn.noisy=function(b){b=c.extend({},c.fn.noisy.defaults,b);var d,a;if(JSON&&localStorage.getItem)a=localStorage.getItem(JSON.stringify(b));if(a)d=a;else{a=document.createElement("canvas");if(a.getContext){a.width=a.height=b.size;for(var h=a.getContext("2d"),e=h.createImageData(a.width,a.height),i=b.intensity*Math.pow(b.size,2),j=255*b.opacity;i--;){var f=(~~(Math.random()*a.width)+~~(Math.random()*a.height)*e.width)*4,g=i%255;e.data[f]=g;e.data[f+1]=b.monochrome?g:~~(Math.random()*255);
e.data[f+2]=b.monochrome?g:~~(Math.random()*255);e.data[f+3]=~~(Math.random()*j)}h.putImageData(e,0,0);d=a.toDataURL("image/png");if(d.indexOf("data:image/png")!=0||c.browser.msie&&c.browser.version.substr(0,1)<9&&d.length>32768)d=b.fallback}else d=b.fallback;JSON&&localStorage&&localStorage.setItem(JSON.stringify(b),d)}return this.each(function(){c(this).css("background-image","url('"+d+"'),"+c(this).css("background-image"))})};c.fn.noisy.defaults={intensity:0.9,size:200,opacity:0.08,fallback:"",
monochrome:false}})(jQuery);

/*
 * jquery.qtip. The jQuery tooltip plugin
 *
 * Copyright (c) 2009 Craig Thompson
 * http://craigsworks.com
 *
 * Licensed under MIT
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Launch  : February 2009
 * Version : 1.0.0-rc3
 * Released: Tuesday 12th May, 2009 - 00:00
 * Debug: jquery.qtip.debug.js
 */
(function(f){f.fn.qtip=function(B,u){var y,t,A,s,x,w,v,z;if(typeof B=="string"){if(typeof f(this).data("qtip")!=="object"){f.fn.qtip.log.error.call(self,1,f.fn.qtip.constants.NO_TOOLTIP_PRESENT,false)}if(B=="api"){return f(this).data("qtip").interfaces[f(this).data("qtip").current]}else{if(B=="interfaces"){return f(this).data("qtip").interfaces}}}else{if(!B){B={}}if(typeof B.content!=="object"||(B.content.jquery&&B.content.length>0)){B.content={text:B.content}}if(typeof B.content.title!=="object"){B.content.title={text:B.content.title}}if(typeof B.position!=="object"){B.position={corner:B.position}}if(typeof B.position.corner!=="object"){B.position.corner={target:B.position.corner,tooltip:B.position.corner}}if(typeof B.show!=="object"){B.show={when:B.show}}if(typeof B.show.when!=="object"){B.show.when={event:B.show.when}}if(typeof B.show.effect!=="object"){B.show.effect={type:B.show.effect}}if(typeof B.hide!=="object"){B.hide={when:B.hide}}if(typeof B.hide.when!=="object"){B.hide.when={event:B.hide.when}}if(typeof B.hide.effect!=="object"){B.hide.effect={type:B.hide.effect}}if(typeof B.style!=="object"){B.style={name:B.style}}B.style=c(B.style);s=f.extend(true,{},f.fn.qtip.defaults,B);s.style=a.call({options:s},s.style);s.user=f.extend(true,{},B)}return f(this).each(function(){if(typeof B=="string"){w=B.toLowerCase();A=f(this).qtip("interfaces");if(typeof A=="object"){if(u===true&&w=="destroy"){while(A.length>0){A[A.length-1].destroy()}}else{if(u!==true){A=[f(this).qtip("api")]}for(y=0;y<A.length;y++){if(w=="destroy"){A[y].destroy()}else{if(A[y].status.rendered===true){if(w=="show"){A[y].show()}else{if(w=="hide"){A[y].hide()}else{if(w=="focus"){A[y].focus()}else{if(w=="disable"){A[y].disable(true)}else{if(w=="enable"){A[y].disable(false)}}}}}}}}}}}else{v=f.extend(true,{},s);v.hide.effect.length=s.hide.effect.length;v.show.effect.length=s.show.effect.length;if(v.position.container===false){v.position.container=f(document.body)}if(v.position.target===false){v.position.target=f(this)}if(v.show.when.target===false){v.show.when.target=f(this)}if(v.hide.when.target===false){v.hide.when.target=f(this)}t=f.fn.qtip.interfaces.length;for(y=0;y<t;y++){if(typeof f.fn.qtip.interfaces[y]=="undefined"){t=y;break}}x=new d(f(this),v,t);f.fn.qtip.interfaces[t]=x;if(typeof f(this).data("qtip")=="object"){if(typeof f(this).attr("qtip")==="undefined"){f(this).data("qtip").current=f(this).data("qtip").interfaces.length}f(this).data("qtip").interfaces.push(x)}else{f(this).data("qtip",{current:0,interfaces:[x]})}if(v.content.prerender===false&&v.show.when.event!==false&&v.show.ready!==true){v.show.when.target.bind(v.show.when.event+".qtip-"+t+"-create",{qtip:t},function(C){z=f.fn.qtip.interfaces[C.data.qtip];z.options.show.when.target.unbind(z.options.show.when.event+".qtip-"+C.data.qtip+"-create");z.cache.mouse={x:C.pageX,y:C.pageY};p.call(z);z.options.show.when.target.trigger(z.options.show.when.event)})}else{x.cache.mouse={x:v.show.when.target.offset().left,y:v.show.when.target.offset().top};p.call(x)}}})};function d(u,t,v){var s=this;s.id=v;s.options=t;s.status={animated:false,rendered:false,disabled:false,focused:false};s.elements={target:u.addClass(s.options.style.classes.target),tooltip:null,wrapper:null,content:null,contentWrapper:null,title:null,button:null,tip:null,bgiframe:null};s.cache={mouse:{},position:{},toggle:0};s.timers={};f.extend(s,s.options.api,{show:function(y){var x,z;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"show")}if(s.elements.tooltip.css("display")!=="none"){return s}s.elements.tooltip.stop(true,false);x=s.beforeShow.call(s,y);if(x===false){return s}function w(){if(s.options.position.type!=="static"){s.focus()}s.onShow.call(s,y);if(f.browser.msie){s.elements.tooltip.get(0).style.removeAttribute("filter")}}s.cache.toggle=1;if(s.options.position.type!=="static"){s.updatePosition(y,(s.options.show.effect.length>0))}if(typeof s.options.show.solo=="object"){z=f(s.options.show.solo)}else{if(s.options.show.solo===true){z=f("div.qtip").not(s.elements.tooltip)}}if(z){z.each(function(){if(f(this).qtip("api").status.rendered===true){f(this).qtip("api").hide()}})}if(typeof s.options.show.effect.type=="function"){s.options.show.effect.type.call(s.elements.tooltip,s.options.show.effect.length);s.elements.tooltip.queue(function(){w();f(this).dequeue()})}else{switch(s.options.show.effect.type.toLowerCase()){case"fade":s.elements.tooltip.fadeIn(s.options.show.effect.length,w);break;case"slide":s.elements.tooltip.slideDown(s.options.show.effect.length,function(){w();if(s.options.position.type!=="static"){s.updatePosition(y,true)}});break;case"grow":s.elements.tooltip.show(s.options.show.effect.length,w);break;default:s.elements.tooltip.show(null,w);break}s.elements.tooltip.addClass(s.options.style.classes.active)}return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_SHOWN,"show")},hide:function(y){var x;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"hide")}else{if(s.elements.tooltip.css("display")==="none"){return s}}clearTimeout(s.timers.show);s.elements.tooltip.stop(true,false);x=s.beforeHide.call(s,y);if(x===false){return s}function w(){s.onHide.call(s,y)}s.cache.toggle=0;if(typeof s.options.hide.effect.type=="function"){s.options.hide.effect.type.call(s.elements.tooltip,s.options.hide.effect.length);s.elements.tooltip.queue(function(){w();f(this).dequeue()})}else{switch(s.options.hide.effect.type.toLowerCase()){case"fade":s.elements.tooltip.fadeOut(s.options.hide.effect.length,w);break;case"slide":s.elements.tooltip.slideUp(s.options.hide.effect.length,w);break;case"grow":s.elements.tooltip.hide(s.options.hide.effect.length,w);break;default:s.elements.tooltip.hide(null,w);break}s.elements.tooltip.removeClass(s.options.style.classes.active)}return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_HIDDEN,"hide")},updatePosition:function(w,x){var C,G,L,J,H,E,y,I,B,D,K,A,F,z;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"updatePosition")}else{if(s.options.position.type=="static"){return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.CANNOT_POSITION_STATIC,"updatePosition")}}G={position:{left:0,top:0},dimensions:{height:0,width:0},corner:s.options.position.corner.target};L={position:s.getPosition(),dimensions:s.getDimensions(),corner:s.options.position.corner.tooltip};if(s.options.position.target!=="mouse"){if(s.options.position.target.get(0).nodeName.toLowerCase()=="area"){J=s.options.position.target.attr("coords").split(",");for(C=0;C<J.length;C++){J[C]=parseInt(J[C])}H=s.options.position.target.parent("map").attr("name");E=f('img[usemap="#'+H+'"]:first').offset();G.position={left:Math.floor(E.left+J[0]),top:Math.floor(E.top+J[1])};switch(s.options.position.target.attr("shape").toLowerCase()){case"rect":G.dimensions={width:Math.ceil(Math.abs(J[2]-J[0])),height:Math.ceil(Math.abs(J[3]-J[1]))};break;case"circle":G.dimensions={width:J[2]+1,height:J[2]+1};break;case"poly":G.dimensions={width:J[0],height:J[1]};for(C=0;C<J.length;C++){if(C%2==0){if(J[C]>G.dimensions.width){G.dimensions.width=J[C]}if(J[C]<J[0]){G.position.left=Math.floor(E.left+J[C])}}else{if(J[C]>G.dimensions.height){G.dimensions.height=J[C]}if(J[C]<J[1]){G.position.top=Math.floor(E.top+J[C])}}}G.dimensions.width=G.dimensions.width-(G.position.left-E.left);G.dimensions.height=G.dimensions.height-(G.position.top-E.top);break;default:return f.fn.qtip.log.error.call(s,4,f.fn.qtip.constants.INVALID_AREA_SHAPE,"updatePosition");break}G.dimensions.width-=2;G.dimensions.height-=2}else{if(s.options.position.target.add(document.body).length===1){G.position={left:f(document).scrollLeft(),top:f(document).scrollTop()};G.dimensions={height:f(window).height(),width:f(window).width()}}else{if(typeof s.options.position.target.attr("qtip")!=="undefined"){G.position=s.options.position.target.qtip("api").cache.position}else{G.position=s.options.position.target.offset()}G.dimensions={height:s.options.position.target.outerHeight(),width:s.options.position.target.outerWidth()}}}y=f.extend({},G.position);if(G.corner.search(/right/i)!==-1){y.left+=G.dimensions.width}if(G.corner.search(/bottom/i)!==-1){y.top+=G.dimensions.height}if(G.corner.search(/((top|bottom)Middle)|center/)!==-1){y.left+=(G.dimensions.width/2)}if(G.corner.search(/((left|right)Middle)|center/)!==-1){y.top+=(G.dimensions.height/2)}}else{G.position=y={left:s.cache.mouse.x,top:s.cache.mouse.y};G.dimensions={height:1,width:1}}if(L.corner.search(/right/i)!==-1){y.left-=L.dimensions.width}if(L.corner.search(/bottom/i)!==-1){y.top-=L.dimensions.height}if(L.corner.search(/((top|bottom)Middle)|center/)!==-1){y.left-=(L.dimensions.width/2)}if(L.corner.search(/((left|right)Middle)|center/)!==-1){y.top-=(L.dimensions.height/2)}I=(f.browser.msie)?1:0;B=(f.browser.msie&&parseInt(f.browser.version.charAt(0))===6)?1:0;if(s.options.style.border.radius>0){if(L.corner.search(/Left/)!==-1){y.left-=s.options.style.border.radius}else{if(L.corner.search(/Right/)!==-1){y.left+=s.options.style.border.radius}}if(L.corner.search(/Top/)!==-1){y.top-=s.options.style.border.radius}else{if(L.corner.search(/Bottom/)!==-1){y.top+=s.options.style.border.radius}}}if(I){if(L.corner.search(/top/)!==-1){y.top-=I}else{if(L.corner.search(/bottom/)!==-1){y.top+=I}}if(L.corner.search(/left/)!==-1){y.left-=I}else{if(L.corner.search(/right/)!==-1){y.left+=I}}if(L.corner.search(/leftMiddle|rightMiddle/)!==-1){y.top-=1}}if(s.options.position.adjust.screen===true){y=o.call(s,y,G,L)}if(s.options.position.target==="mouse"&&s.options.position.adjust.mouse===true){if(s.options.position.adjust.screen===true&&s.elements.tip){K=s.elements.tip.attr("rel")}else{K=s.options.position.corner.tooltip}y.left+=(K.search(/right/i)!==-1)?-6:6;y.top+=(K.search(/bottom/i)!==-1)?-6:6}if(!s.elements.bgiframe&&f.browser.msie&&parseInt(f.browser.version.charAt(0))==6){f("select, object").each(function(){A=f(this).offset();A.bottom=A.top+f(this).height();A.right=A.left+f(this).width();if(y.top+L.dimensions.height>=A.top&&y.left+L.dimensions.width>=A.left){k.call(s)}})}y.left+=s.options.position.adjust.x;y.top+=s.options.position.adjust.y;F=s.getPosition();if(y.left!=F.left||y.top!=F.top){z=s.beforePositionUpdate.call(s,w);if(z===false){return s}s.cache.position=y;if(x===true){s.status.animated=true;s.elements.tooltip.animate(y,200,"swing",function(){s.status.animated=false})}else{s.elements.tooltip.css(y)}s.onPositionUpdate.call(s,w);if(typeof w!=="undefined"&&w.type&&w.type!=="mousemove"){f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_POSITION_UPDATED,"updatePosition")}}return s},updateWidth:function(w){var x;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"updateWidth")}else{if(w&&typeof w!=="number"){return f.fn.qtip.log.error.call(s,2,"newWidth must be of type number","updateWidth")}}x=s.elements.contentWrapper.siblings().add(s.elements.tip).add(s.elements.button);if(!w){if(typeof s.options.style.width.value=="number"){w=s.options.style.width.value}else{s.elements.tooltip.css({width:"auto"});x.hide();if(f.browser.msie){s.elements.wrapper.add(s.elements.contentWrapper.children()).css({zoom:"normal"})}w=s.getDimensions().width+1;if(!s.options.style.width.value){if(w>s.options.style.width.max){w=s.options.style.width.max}if(w<s.options.style.width.min){w=s.options.style.width.min}}}}if(w%2!==0){w-=1}s.elements.tooltip.width(w);x.show();if(s.options.style.border.radius){s.elements.tooltip.find(".qtip-betweenCorners").each(function(y){f(this).width(w-(s.options.style.border.radius*2))})}if(f.browser.msie){s.elements.wrapper.add(s.elements.contentWrapper.children()).css({zoom:"1"});s.elements.wrapper.width(w);if(s.elements.bgiframe){s.elements.bgiframe.width(w).height(s.getDimensions.height)}}return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_WIDTH_UPDATED,"updateWidth")},updateStyle:function(w){var z,A,x,y,B;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"updateStyle")}else{if(typeof w!=="string"||!f.fn.qtip.styles[w]){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.STYLE_NOT_DEFINED,"updateStyle")}}s.options.style=a.call(s,f.fn.qtip.styles[w],s.options.user.style);s.elements.content.css(q(s.options.style));if(s.options.content.title.text!==false){s.elements.title.css(q(s.options.style.title,true))}s.elements.contentWrapper.css({borderColor:s.options.style.border.color});if(s.options.style.tip.corner!==false){if(f("<canvas>").get(0).getContext){z=s.elements.tooltip.find(".qtip-tip canvas:first");x=z.get(0).getContext("2d");x.clearRect(0,0,300,300);y=z.parent("div[rel]:first").attr("rel");B=b(y,s.options.style.tip.size.width,s.options.style.tip.size.height);h.call(s,z,B,s.options.style.tip.color||s.options.style.border.color)}else{if(f.browser.msie){z=s.elements.tooltip.find('.qtip-tip [nodeName="shape"]');z.attr("fillcolor",s.options.style.tip.color||s.options.style.border.color)}}}if(s.options.style.border.radius>0){s.elements.tooltip.find(".qtip-betweenCorners").css({backgroundColor:s.options.style.border.color});if(f("<canvas>").get(0).getContext){A=g(s.options.style.border.radius);s.elements.tooltip.find(".qtip-wrapper canvas").each(function(){x=f(this).get(0).getContext("2d");x.clearRect(0,0,300,300);y=f(this).parent("div[rel]:first").attr("rel");r.call(s,f(this),A[y],s.options.style.border.radius,s.options.style.border.color)})}else{if(f.browser.msie){s.elements.tooltip.find('.qtip-wrapper [nodeName="arc"]').each(function(){f(this).attr("fillcolor",s.options.style.border.color)})}}}return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_STYLE_UPDATED,"updateStyle")},updateContent:function(A,y){var z,x,w;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"updateContent")}else{if(!A){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.NO_CONTENT_PROVIDED,"updateContent")}}z=s.beforeContentUpdate.call(s,A);if(typeof z=="string"){A=z}else{if(z===false){return}}if(f.browser.msie){s.elements.contentWrapper.children().css({zoom:"normal"})}if(A.jquery&&A.length>0){A.clone(true).appendTo(s.elements.content).show()}else{s.elements.content.html(A)}x=s.elements.content.find("img[complete=false]");if(x.length>0){w=0;x.each(function(C){f('<img src="'+f(this).attr("src")+'" />').load(function(){if(++w==x.length){B()}})})}else{B()}function B(){s.updateWidth();if(y!==false){if(s.options.position.type!=="static"){s.updatePosition(s.elements.tooltip.is(":visible"),true)}if(s.options.style.tip.corner!==false){n.call(s)}}}s.onContentUpdate.call(s);return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_CONTENT_UPDATED,"loadContent")},loadContent:function(w,z,A){var y;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"loadContent")}y=s.beforeContentLoad.call(s);if(y===false){return s}if(A=="post"){f.post(w,z,x)}else{f.get(w,z,x)}function x(B){s.onContentLoad.call(s);f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_CONTENT_LOADED,"loadContent");s.updateContent(B)}return s},updateTitle:function(w){if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"updateTitle")}else{if(!w){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.NO_CONTENT_PROVIDED,"updateTitle")}}returned=s.beforeTitleUpdate.call(s);if(returned===false){return s}if(s.elements.button){s.elements.button=s.elements.button.clone(true)}s.elements.title.html(w);if(s.elements.button){s.elements.title.prepend(s.elements.button)}s.onTitleUpdate.call(s);return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_TITLE_UPDATED,"updateTitle")},focus:function(A){var y,x,w,z;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"focus")}else{if(s.options.position.type=="static"){return f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.CANNOT_FOCUS_STATIC,"focus")}}y=parseInt(s.elements.tooltip.css("z-index"));x=6000+f("div.qtip[qtip]").length-1;if(!s.status.focused&&y!==x){z=s.beforeFocus.call(s,A);if(z===false){return s}f("div.qtip[qtip]").not(s.elements.tooltip).each(function(){if(f(this).qtip("api").status.rendered===true){w=parseInt(f(this).css("z-index"));if(typeof w=="number"&&w>-1){f(this).css({zIndex:parseInt(f(this).css("z-index"))-1})}f(this).qtip("api").status.focused=false}});s.elements.tooltip.css({zIndex:x});s.status.focused=true;s.onFocus.call(s,A);f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_FOCUSED,"focus")}return s},disable:function(w){if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"disable")}if(w){if(!s.status.disabled){s.status.disabled=true;f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_DISABLED,"disable")}else{f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.TOOLTIP_ALREADY_DISABLED,"disable")}}else{if(s.status.disabled){s.status.disabled=false;f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_ENABLED,"disable")}else{f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.TOOLTIP_ALREADY_ENABLED,"disable")}}return s},destroy:function(){var w,x,y;x=s.beforeDestroy.call(s);if(x===false){return s}if(s.status.rendered){s.options.show.when.target.unbind("mousemove.qtip",s.updatePosition);s.options.show.when.target.unbind("mouseout.qtip",s.hide);s.options.show.when.target.unbind(s.options.show.when.event+".qtip");s.options.hide.when.target.unbind(s.options.hide.when.event+".qtip");s.elements.tooltip.unbind(s.options.hide.when.event+".qtip");s.elements.tooltip.unbind("mouseover.qtip",s.focus);s.elements.tooltip.remove()}else{s.options.show.when.target.unbind(s.options.show.when.event+".qtip-create")}if(typeof s.elements.target.data("qtip")=="object"){y=s.elements.target.data("qtip").interfaces;if(typeof y=="object"&&y.length>0){for(w=0;w<y.length-1;w++){if(y[w].id==s.id){y.splice(w,1)}}}}delete f.fn.qtip.interfaces[s.id];if(typeof y=="object"&&y.length>0){s.elements.target.data("qtip").current=y.length-1}else{s.elements.target.removeData("qtip")}s.onDestroy.call(s);f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_DESTROYED,"destroy");return s.elements.target},getPosition:function(){var w,x;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"getPosition")}w=(s.elements.tooltip.css("display")!=="none")?false:true;if(w){s.elements.tooltip.css({visiblity:"hidden"}).show()}x=s.elements.tooltip.offset();if(w){s.elements.tooltip.css({visiblity:"visible"}).hide()}return x},getDimensions:function(){var w,x;if(!s.status.rendered){return f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.TOOLTIP_NOT_RENDERED,"getDimensions")}w=(!s.elements.tooltip.is(":visible"))?true:false;if(w){s.elements.tooltip.css({visiblity:"hidden"}).show()}x={height:s.elements.tooltip.outerHeight(),width:s.elements.tooltip.outerWidth()};if(w){s.elements.tooltip.css({visiblity:"visible"}).hide()}return x}})}function p(){var s,w,u,t,v,y,x;s=this;s.beforeRender.call(s);s.status.rendered=true;s.elements.tooltip='<div qtip="'+s.id+'" class="qtip '+(s.options.style.classes.tooltip||s.options.style)+'"style="display:none; -moz-border-radius:0; -webkit-border-radius:0; border-radius:0;position:'+s.options.position.type+';">  <div class="qtip-wrapper" style="position:relative; overflow:hidden; text-align:left;">    <div class="qtip-contentWrapper" style="overflow:hidden;">       <div class="qtip-content '+s.options.style.classes.content+'"></div></div></div></div>';s.elements.tooltip=f(s.elements.tooltip);s.elements.tooltip.appendTo(s.options.position.container);s.elements.tooltip.data("qtip",{current:0,interfaces:[s]});s.elements.wrapper=s.elements.tooltip.children("div:first");s.elements.contentWrapper=s.elements.wrapper.children("div:first").css({background:s.options.style.background});s.elements.content=s.elements.contentWrapper.children("div:first").css(q(s.options.style));if(f.browser.msie){s.elements.wrapper.add(s.elements.content).css({zoom:1})}if(s.options.hide.when.event=="unfocus"){s.elements.tooltip.attr("unfocus",true)}if(typeof s.options.style.width.value=="number"){s.updateWidth()}if(f("<canvas>").get(0).getContext||f.browser.msie){if(s.options.style.border.radius>0){m.call(s)}else{s.elements.contentWrapper.css({border:s.options.style.border.width+"px solid "+s.options.style.border.color})}if(s.options.style.tip.corner!==false){e.call(s)}}else{s.elements.contentWrapper.css({border:s.options.style.border.width+"px solid "+s.options.style.border.color});s.options.style.border.radius=0;s.options.style.tip.corner=false;f.fn.qtip.log.error.call(s,2,f.fn.qtip.constants.CANVAS_VML_NOT_SUPPORTED,"render")}if((typeof s.options.content.text=="string"&&s.options.content.text.length>0)||(s.options.content.text.jquery&&s.options.content.text.length>0)){u=s.options.content.text}else{if(typeof s.elements.target.attr("title")=="string"&&s.elements.target.attr("title").length>0){u=s.elements.target.attr("title").replace("\\n","<br />");s.elements.target.attr("title","")}else{if(typeof s.elements.target.attr("alt")=="string"&&s.elements.target.attr("alt").length>0){u=s.elements.target.attr("alt").replace("\\n","<br />");s.elements.target.attr("alt","")}else{u=" ";f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.NO_VALID_CONTENT,"render")}}}if(s.options.content.title.text!==false){j.call(s)}s.updateContent(u);l.call(s);if(s.options.show.ready===true){s.show()}if(s.options.content.url!==false){t=s.options.content.url;v=s.options.content.data;y=s.options.content.method||"get";s.loadContent(t,v,y)}s.onRender.call(s);f.fn.qtip.log.error.call(s,1,f.fn.qtip.constants.EVENT_RENDERED,"render")}function m(){var F,z,t,B,x,E,u,G,D,y,w,C,A,s,v;F=this;F.elements.wrapper.find(".qtip-borderBottom, .qtip-borderTop").remove();t=F.options.style.border.width;B=F.options.style.border.radius;x=F.options.style.border.color||F.options.style.tip.color;E=g(B);u={};for(z in E){u[z]='<div rel="'+z+'" style="'+((z.search(/Left/)!==-1)?"left":"right")+":0; position:absolute; height:"+B+"px; width:"+B+'px; overflow:hidden; line-height:0.1px; font-size:1px">';if(f("<canvas>").get(0).getContext){u[z]+='<canvas height="'+B+'" width="'+B+'" style="vertical-align: top"></canvas>'}else{if(f.browser.msie){G=B*2+3;u[z]+='<v:arc stroked="false" fillcolor="'+x+'" startangle="'+E[z][0]+'" endangle="'+E[z][1]+'" style="width:'+G+"px; height:"+G+"px; margin-top:"+((z.search(/bottom/)!==-1)?-2:-1)+"px; margin-left:"+((z.search(/Right/)!==-1)?E[z][2]-3.5:-1)+'px; vertical-align:top; display:inline-block; behavior:url(#default#VML)"></v:arc>'}}u[z]+="</div>"}D=F.getDimensions().width-(Math.max(t,B)*2);y='<div class="qtip-betweenCorners" style="height:'+B+"px; width:"+D+"px; overflow:hidden; background-color:"+x+'; line-height:0.1px; font-size:1px;">';w='<div class="qtip-borderTop" dir="ltr" style="height:'+B+"px; margin-left:"+B+'px; line-height:0.1px; font-size:1px; padding:0;">'+u.topLeft+u.topRight+y;F.elements.wrapper.prepend(w);C='<div class="qtip-borderBottom" dir="ltr" style="height:'+B+"px; margin-left:"+B+'px; line-height:0.1px; font-size:1px; padding:0;">'+u.bottomLeft+u.bottomRight+y;F.elements.wrapper.append(C);if(f("<canvas>").get(0).getContext){F.elements.wrapper.find("canvas").each(function(){A=E[f(this).parent("[rel]:first").attr("rel")];r.call(F,f(this),A,B,x)})}else{if(f.browser.msie){F.elements.tooltip.append('<v:image style="behavior:url(#default#VML);"></v:image>')}}s=Math.max(B,(B+(t-B)));v=Math.max(t-B,0);F.elements.contentWrapper.css({border:"0px solid "+x,borderWidth:v+"px "+s+"px"})}function r(u,w,s,t){var v=u.get(0).getContext("2d");v.fillStyle=t;v.beginPath();v.arc(w[0],w[1],s,0,Math.PI*2,false);v.fill()}function e(v){var t,s,x,u,w;t=this;if(t.elements.tip!==null){t.elements.tip.remove()}s=t.options.style.tip.color||t.options.style.border.color;if(t.options.style.tip.corner===false){return}else{if(!v){v=t.options.style.tip.corner}}x=b(v,t.options.style.tip.size.width,t.options.style.tip.size.height);t.elements.tip='<div class="'+t.options.style.classes.tip+'" dir="ltr" rel="'+v+'" style="position:absolute; height:'+t.options.style.tip.size.height+"px; width:"+t.options.style.tip.size.width+'px; margin:0 auto; line-height:0.1px; font-size:1px;">';if(f("<canvas>").get(0).getContext){t.elements.tip+='<canvas height="'+t.options.style.tip.size.height+'" width="'+t.options.style.tip.size.width+'"></canvas>'}else{if(f.browser.msie){u=t.options.style.tip.size.width+","+t.options.style.tip.size.height;w="m"+x[0][0]+","+x[0][1];w+=" l"+x[1][0]+","+x[1][1];w+=" "+x[2][0]+","+x[2][1];w+=" xe";t.elements.tip+='<v:shape fillcolor="'+s+'" stroked="false" filled="true" path="'+w+'" coordsize="'+u+'" style="width:'+t.options.style.tip.size.width+"px; height:"+t.options.style.tip.size.height+"px; line-height:0.1px; display:inline-block; behavior:url(#default#VML); vertical-align:"+((v.search(/top/)!==-1)?"bottom":"top")+'"></v:shape>';t.elements.tip+='<v:image style="behavior:url(#default#VML);"></v:image>';t.elements.contentWrapper.css("position","relative")}}t.elements.tooltip.prepend(t.elements.tip+"</div>");t.elements.tip=t.elements.tooltip.find("."+t.options.style.classes.tip).eq(0);if(f("<canvas>").get(0).getContext){h.call(t,t.elements.tip.find("canvas:first"),x,s)}if(v.search(/top/)!==-1&&f.browser.msie&&parseInt(f.browser.version.charAt(0))===6){t.elements.tip.css({marginTop:-4})}n.call(t,v)}function h(t,v,s){var u=t.get(0).getContext("2d");u.fillStyle=s;u.beginPath();u.moveTo(v[0][0],v[0][1]);u.lineTo(v[1][0],v[1][1]);u.lineTo(v[2][0],v[2][1]);u.fill()}function n(u){var t,w,s,x,v;t=this;if(t.options.style.tip.corner===false||!t.elements.tip){return}if(!u){u=t.elements.tip.attr("rel")}w=positionAdjust=(f.browser.msie)?1:0;t.elements.tip.css(u.match(/left|right|top|bottom/)[0],0);if(u.search(/top|bottom/)!==-1){if(f.browser.msie){if(parseInt(f.browser.version.charAt(0))===6){positionAdjust=(u.search(/top/)!==-1)?-3:1}else{positionAdjust=(u.search(/top/)!==-1)?1:2}}if(u.search(/Middle/)!==-1){t.elements.tip.css({left:"50%",marginLeft:-(t.options.style.tip.size.width/2)})}else{if(u.search(/Left/)!==-1){t.elements.tip.css({left:t.options.style.border.radius-w})}else{if(u.search(/Right/)!==-1){t.elements.tip.css({right:t.options.style.border.radius+w})}}}if(u.search(/top/)!==-1){t.elements.tip.css({top:-positionAdjust})}else{t.elements.tip.css({bottom:positionAdjust})}}else{if(u.search(/left|right/)!==-1){if(f.browser.msie){positionAdjust=(parseInt(f.browser.version.charAt(0))===6)?1:((u.search(/left/)!==-1)?1:2)}if(u.search(/Middle/)!==-1){t.elements.tip.css({top:"50%",marginTop:-(t.options.style.tip.size.height/2)})}else{if(u.search(/Top/)!==-1){t.elements.tip.css({top:t.options.style.border.radius-w})}else{if(u.search(/Bottom/)!==-1){t.elements.tip.css({bottom:t.options.style.border.radius+w})}}}if(u.search(/left/)!==-1){t.elements.tip.css({left:-positionAdjust})}else{t.elements.tip.css({right:positionAdjust})}}}s="padding-"+u.match(/left|right|top|bottom/)[0];x=t.options.style.tip.size[(s.search(/left|right/)!==-1)?"width":"height"];t.elements.tooltip.css("padding",0);t.elements.tooltip.css(s,x);if(f.browser.msie&&parseInt(f.browser.version.charAt(0))==6){v=parseInt(t.elements.tip.css("margin-top"))||0;v+=parseInt(t.elements.content.css("margin-top"))||0;t.elements.tip.css({marginTop:v})}}function j(){var s=this;if(s.elements.title!==null){s.elements.title.remove()}s.elements.title=f('<div class="'+s.options.style.classes.title+'">').css(q(s.options.style.title,true)).css({zoom:(f.browser.msie)?1:0}).prependTo(s.elements.contentWrapper);if(s.options.content.title.text){s.updateTitle.call(s,s.options.content.title.text)}if(s.options.content.title.button!==false&&typeof s.options.content.title.button=="string"){s.elements.button=f('<a class="'+s.options.style.classes.button+'" style="float:right; position: relative"></a>').css(q(s.options.style.button,true)).html(s.options.content.title.button).prependTo(s.elements.title).click(function(t){if(!s.status.disabled){s.hide(t)}})}}function l(){var t,v,u,s;t=this;v=t.options.show.when.target;u=t.options.hide.when.target;if(t.options.hide.fixed){u=u.add(t.elements.tooltip)}if(t.options.hide.when.event=="inactive"){s=["click","dblclick","mousedown","mouseup","mousemove","mouseout","mouseenter","mouseleave","mouseover"];function y(z){if(t.status.disabled===true){return}clearTimeout(t.timers.inactive);t.timers.inactive=setTimeout(function(){f(s).each(function(){u.unbind(this+".qtip-inactive");t.elements.content.unbind(this+".qtip-inactive")});t.hide(z)},t.options.hide.delay)}}else{if(t.options.hide.fixed===true){t.elements.tooltip.bind("mouseover.qtip",function(){if(t.status.disabled===true){return}clearTimeout(t.timers.hide)})}}function x(z){if(t.status.disabled===true){return}if(t.options.hide.when.event=="inactive"){f(s).each(function(){u.bind(this+".qtip-inactive",y);t.elements.content.bind(this+".qtip-inactive",y)});y()}clearTimeout(t.timers.show);clearTimeout(t.timers.hide);t.timers.show=setTimeout(function(){t.show(z)},t.options.show.delay)}function w(z){if(t.status.disabled===true){return}if(t.options.hide.fixed===true&&t.options.hide.when.event.search(/mouse(out|leave)/i)!==-1&&f(z.relatedTarget).parents("div.qtip[qtip]").length>0){z.stopPropagation();z.preventDefault();clearTimeout(t.timers.hide);return false}clearTimeout(t.timers.show);clearTimeout(t.timers.hide);t.elements.tooltip.stop(true,true);t.timers.hide=setTimeout(function(){t.hide(z)},t.options.hide.delay)}if((t.options.show.when.target.add(t.options.hide.when.target).length===1&&t.options.show.when.event==t.options.hide.when.event&&t.options.hide.when.event!=="inactive")||t.options.hide.when.event=="unfocus"){t.cache.toggle=0;v.bind(t.options.show.when.event+".qtip",function(z){if(t.cache.toggle==0){x(z)}else{w(z)}})}else{v.bind(t.options.show.when.event+".qtip",x);if(t.options.hide.when.event!=="inactive"){u.bind(t.options.hide.when.event+".qtip",w)}}if(t.options.position.type.search(/(fixed|absolute)/)!==-1){t.elements.tooltip.bind("mouseover.qtip",t.focus)}if(t.options.position.target==="mouse"&&t.options.position.type!=="static"){v.bind("mousemove.qtip",function(z){t.cache.mouse={x:z.pageX,y:z.pageY};if(t.status.disabled===false&&t.options.position.adjust.mouse===true&&t.options.position.type!=="static"&&t.elements.tooltip.css("display")!=="none"){t.updatePosition(z)}})}}function o(u,v,A){var z,s,x,y,t,w;z=this;if(A.corner=="center"){return v.position}s=f.extend({},u);y={x:false,y:false};t={left:(s.left<f.fn.qtip.cache.screen.scroll.left),right:(s.left+A.dimensions.width+2>=f.fn.qtip.cache.screen.width+f.fn.qtip.cache.screen.scroll.left),top:(s.top<f.fn.qtip.cache.screen.scroll.top),bottom:(s.top+A.dimensions.height+2>=f.fn.qtip.cache.screen.height+f.fn.qtip.cache.screen.scroll.top)};x={left:(t.left&&(A.corner.search(/right/i)!=-1||(A.corner.search(/right/i)==-1&&!t.right))),right:(t.right&&(A.corner.search(/left/i)!=-1||(A.corner.search(/left/i)==-1&&!t.left))),top:(t.top&&A.corner.search(/top/i)==-1),bottom:(t.bottom&&A.corner.search(/bottom/i)==-1)};if(x.left){if(z.options.position.target!=="mouse"){s.left=v.position.left+v.dimensions.width}else{s.left=z.cache.mouse.x}y.x="Left"}else{if(x.right){if(z.options.position.target!=="mouse"){s.left=v.position.left-A.dimensions.width}else{s.left=z.cache.mouse.x-A.dimensions.width}y.x="Right"}}if(x.top){if(z.options.position.target!=="mouse"){s.top=v.position.top+v.dimensions.height}else{s.top=z.cache.mouse.y}y.y="top"}else{if(x.bottom){if(z.options.position.target!=="mouse"){s.top=v.position.top-A.dimensions.height}else{s.top=z.cache.mouse.y-A.dimensions.height}y.y="bottom"}}if(s.left<0){s.left=u.left;y.x=false}if(s.top<0){s.top=u.top;y.y=false}if(z.options.style.tip.corner!==false){s.corner=new String(A.corner);if(y.x!==false){s.corner=s.corner.replace(/Left|Right|Middle/,y.x)}if(y.y!==false){s.corner=s.corner.replace(/top|bottom/,y.y)}if(s.corner!==z.elements.tip.attr("rel")){e.call(z,s.corner)}}return s}function q(u,t){var v,s;v=f.extend(true,{},u);for(s in v){if(t===true&&s.search(/(tip|classes)/i)!==-1){delete v[s]}else{if(!t&&s.search(/(width|border|tip|title|classes|user)/i)!==-1){delete v[s]}}}return v}function c(s){if(typeof s.tip!=="object"){s.tip={corner:s.tip}}if(typeof s.tip.size!=="object"){s.tip.size={width:s.tip.size,height:s.tip.size}}if(typeof s.border!=="object"){s.border={width:s.border}}if(typeof s.width!=="object"){s.width={value:s.width}}if(typeof s.width.max=="string"){s.width.max=parseInt(s.width.max.replace(/([0-9]+)/i,"$1"))}if(typeof s.width.min=="string"){s.width.min=parseInt(s.width.min.replace(/([0-9]+)/i,"$1"))}if(typeof s.tip.size.x=="number"){s.tip.size.width=s.tip.size.x;delete s.tip.size.x}if(typeof s.tip.size.y=="number"){s.tip.size.height=s.tip.size.y;delete s.tip.size.y}return s}function a(){var s,t,u,x,v,w;s=this;u=[true,{}];for(t=0;t<arguments.length;t++){u.push(arguments[t])}x=[f.extend.apply(f,u)];while(typeof x[0].name=="string"){x.unshift(c(f.fn.qtip.styles[x[0].name]))}x.unshift(true,{classes:{tooltip:"qtip-"+(arguments[0].name||"defaults")}},f.fn.qtip.styles.defaults);v=f.extend.apply(f,x);w=(f.browser.msie)?1:0;v.tip.size.width+=w;v.tip.size.height+=w;if(v.tip.size.width%2>0){v.tip.size.width+=1}if(v.tip.size.height%2>0){v.tip.size.height+=1}if(v.tip.corner===true){v.tip.corner=(s.options.position.corner.tooltip==="center")?false:s.options.position.corner.tooltip}return v}function b(v,u,t){var s={bottomRight:[[0,0],[u,t],[u,0]],bottomLeft:[[0,0],[u,0],[0,t]],topRight:[[0,t],[u,0],[u,t]],topLeft:[[0,0],[0,t],[u,t]],topMiddle:[[0,t],[u/2,0],[u,t]],bottomMiddle:[[0,0],[u,0],[u/2,t]],rightMiddle:[[0,0],[u,t/2],[0,t]],leftMiddle:[[u,0],[u,t],[0,t/2]]};s.leftTop=s.bottomRight;s.rightTop=s.bottomLeft;s.leftBottom=s.topRight;s.rightBottom=s.topLeft;return s[v]}function g(s){var t;if(f("<canvas>").get(0).getContext){t={topLeft:[s,s],topRight:[0,s],bottomLeft:[s,0],bottomRight:[0,0]}}else{if(f.browser.msie){t={topLeft:[-90,90,0],topRight:[-90,90,-s],bottomLeft:[90,270,0],bottomRight:[90,270,-s]}}}return t}function k(){var s,t,u;s=this;u=s.getDimensions();t='<iframe class="qtip-bgiframe" frameborder="0" tabindex="-1" src="javascript:false" style="display:block; position:absolute; z-index:-1; filter:alpha(opacity=\'0\'); border: 1px solid red; height:'+u.height+"px; width:"+u.width+'px" />';s.elements.bgiframe=s.elements.wrapper.prepend(t).children(".qtip-bgiframe:first")}f(document).ready(function(){f.fn.qtip.cache={screen:{scroll:{left:f(window).scrollLeft(),top:f(window).scrollTop()},width:f(window).width(),height:f(window).height()}};var s;f(window).bind("resize scroll",function(t){clearTimeout(s);s=setTimeout(function(){if(t.type==="scroll"){f.fn.qtip.cache.screen.scroll={left:f(window).scrollLeft(),top:f(window).scrollTop()}}else{f.fn.qtip.cache.screen.width=f(window).width();f.fn.qtip.cache.screen.height=f(window).height()}for(i=0;i<f.fn.qtip.interfaces.length;i++){var u=f.fn.qtip.interfaces[i];if(u.status.rendered===true&&(u.options.position.type!=="static"||u.options.position.adjust.scroll&&t.type==="scroll"||u.options.position.adjust.resize&&t.type==="resize")){u.updatePosition(t,true)}}},100)});f(document).bind("mousedown.qtip",function(t){if(f(t.target).parents("div.qtip").length===0){f(".qtip[unfocus]").each(function(){var u=f(this).qtip("api");if(f(this).is(":visible")&&!u.status.disabled&&f(t.target).add(u.elements.target).length>1){u.hide(t)}})}})});f.fn.qtip.interfaces=[];f.fn.qtip.log={error:function(){return this}};f.fn.qtip.constants={};f.fn.qtip.defaults={content:{prerender:false,text:false,url:false,data:null,title:{text:false,button:false}},position:{target:false,corner:{target:"bottomRight",tooltip:"topLeft"},adjust:{x:0,y:0,mouse:true,screen:false,scroll:true,resize:true},type:"absolute",container:false},show:{when:{target:false,event:"mouseover"},effect:{type:"fade",length:100},delay:140,solo:false,ready:false},hide:{when:{target:false,event:"mouseout"},effect:{type:"fade",length:100},delay:0,fixed:false},api:{beforeRender:function(){},onRender:function(){},beforePositionUpdate:function(){},onPositionUpdate:function(){},beforeShow:function(){},onShow:function(){},beforeHide:function(){},onHide:function(){},beforeContentUpdate:function(){},onContentUpdate:function(){},beforeContentLoad:function(){},onContentLoad:function(){},beforeTitleUpdate:function(){},onTitleUpdate:function(){},beforeDestroy:function(){},onDestroy:function(){},beforeFocus:function(){},onFocus:function(){}}};f.fn.qtip.styles={defaults:{background:"white",color:"#111",overflow:"hidden",textAlign:"left",width:{min:0,max:250},padding:"5px 9px",border:{width:1,radius:0,color:"#d3d3d3"},tip:{corner:false,color:false,size:{width:13,height:13},opacity:1},title:{background:"#e1e1e1",fontWeight:"bold",padding:"7px 12px"},button:{cursor:"pointer"},classes:{target:"",tip:"qtip-tip",title:"qtip-title",button:"qtip-button",content:"qtip-content",active:"qtip-active"}},cream:{border:{width:3,radius:0,color:"#F9E98E"},title:{background:"#F0DE7D",color:"#A27D35"},background:"#FBF7AA",color:"#A27D35",classes:{tooltip:"qtip-cream"}},light:{border:{width:3,radius:0,color:"#E2E2E2"},title:{background:"#f1f1f1",color:"#454545"},background:"white",color:"#454545",classes:{tooltip:"qtip-light"}},dark:{border:{width:3,radius:0,color:"#303030"},title:{background:"#404040",color:"#f3f3f3"},background:"#505050",color:"#f3f3f3",classes:{tooltip:"qtip-dark"}},red:{border:{width:3,radius:0,color:"#CE6F6F"},title:{background:"#f28279",color:"#9C2F2F"},background:"#F79992",color:"#9C2F2F",classes:{tooltip:"qtip-red"}},green:{border:{width:3,radius:0,color:"#A9DB66"},title:{background:"#b9db8c",color:"#58792E"},background:"#CDE6AC",color:"#58792E",classes:{tooltip:"qtip-green"}},blue:{border:{width:3,radius:0,color:"#ADD9ED"},title:{background:"#D0E9F5",color:"#5E99BD"},background:"#E5F6FE",color:"#4D9FBF",classes:{tooltip:"qtip-blue"}}}})(jQuery);
/*
 * jquery-ujs
 *
 * http://github.com/rails/jquery-ujs/blob/master/src/rails.js
 *
 * This rails.js file supports jQuery 1.4.3 and 1.4.4 .
 *
 */

jQuery(function ($) {
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content');

    $.fn.extend({
        /**
         * Triggers a custom event on an element and returns the event result
         * this is used to get around not being able to ensure callbacks are placed
         * at the end of the chain.
         *
         * TODO: deprecate with jQuery 1.4.2 release, in favor of subscribing to our
         *       own events and placing ourselves at the end of the chain.
         */
        triggerAndReturn: function (name, data) {
            var event = new $.Event(name);
            this.trigger(event, data);

            return event.result !== false;
        },

        /**
         * Handles execution of remote calls. Provides following callbacks:
         *
         * - ajax:beforeSend  - is executed before firing ajax call
         * - ajax:success  - is executed when status is success
         * - ajax:complete - is executed when the request finishes, whether in failure or success.
         * - ajax:error    - is execute in case of error
         */
        callRemote: function () {
            var el      = this,
                method  = el.attr('method') || el.attr('data-method') || 'GET',
                url     = el.attr('action') || el.attr('href'),
                dataType  = el.attr('data-type')  || ($.ajaxSettings && $.ajaxSettings.dataType);

            if (url === undefined) {
                throw "No URL specified for remote call (action or href must be present).";
            } else {
                    var $this = $(this), data = el.is('form') ? el.serializeArray() : [];

                    $.ajax({
                        url: url,
                        data: data,
                        dataType: dataType,
                        type: method.toUpperCase(),
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("Accept", "text/javascript");
                            if ($this.triggerHandler('ajax:beforeSend') === false) {
                              return false;
                            }
                        },
                        success: function (data, status, xhr) {
                            el.trigger('ajax:success', [data, status, xhr]);
                        },
                        complete: function (xhr) {
                            el.trigger('ajax:complete', xhr);
                        },
                        error: function (xhr, status, error) {
                            el.trigger('ajax:error', [xhr, status, error]);
                        }
                    });
            }
        }
    });

    /**
     *  confirmation handler
     */

    $('body').delegate('a[data-confirm], button[data-confirm], input[data-confirm]', 'click.rails', function () {
        var el = $(this);
        if (el.triggerAndReturn('confirm')) {
            if (!confirm(el.attr('data-confirm'))) {
                return false;
            }
        }
    });



    /**
     * remote handlers
     */
    $('form[data-remote]').live('submit.rails', function (e) {
        $(this).callRemote();
        e.preventDefault();
    });

    $('a[data-remote],input[data-remote]').live('click.rails', function (e) {
        $(this).callRemote();
        e.preventDefault();
    });

    /**
     * <%= link_to "Delete", user_path(@user), :method => :delete, :confirm => "Are you sure?" %>
     *
     * <a href="/users/5" data-confirm="Are you sure?" data-method="delete" rel="nofollow">Delete</a>
     */
    $('a[data-method]:not([data-remote])').live('click.rails', function (e){
        var link = $(this),
            href = link.attr('href'),
            method = link.attr('data-method'),
            form = $('<form method="post" action="'+href+'"></form>'),
            metadata_input = '<input name="_method" value="'+method+'" type="hidden" />';

        if (csrf_param !== undefined && csrf_token !== undefined) {
            metadata_input += '<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />';
        }

        form.hide()
            .append(metadata_input)
            .appendTo('body');

        e.preventDefault();
        form.submit();
    });

    /**
     * disable-with handlers
     */
    var disable_with_input_selector           = 'input[data-disable-with]',
        disable_with_form_remote_selector     = 'form[data-remote]:has('       + disable_with_input_selector + ')',
        disable_with_form_not_remote_selector = 'form:not([data-remote]):has(' + disable_with_input_selector + ')';

    var disable_with_input_function = function () {
        $(this).find(disable_with_input_selector).each(function () {
            var input = $(this);
            input.data('enable-with', input.val())
                .attr('value', input.attr('data-disable-with'))
                .attr('disabled', 'disabled');
        });
    };

    $(disable_with_form_remote_selector).live('ajax:before.rails', disable_with_input_function);
    $(disable_with_form_not_remote_selector).live('submit.rails', disable_with_input_function);

    $(disable_with_form_remote_selector).live('ajax:complete.rails', function () {
        $(this).find(disable_with_input_selector).each(function () {
            var input = $(this);
            input.removeAttr('disabled')
                 .val(input.data('enable-with'));
        });
    });

    var jqueryVersion = $().jquery;

	if (!( (jqueryVersion === '1.4.3') || (jqueryVersion === '1.4.4'))){
		alert('This rails.js does not support the jQuery version you are using. Please read documentation.');
	}


});
