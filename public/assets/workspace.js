// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//'#E8E8E2'

$(document).ready(function() {


$("#foo3").carouFredSel({
	circular: false,
	infinite: false,
    items : "variable",
	auto : false,
	prev : {	
		button	: "#foo3_prev",
		key		: "left"
	},
	next : { 
		button	: "#foo3_next",
		key		: "right"
	}
});

//$('#foo').slides(); //start the carousel

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
                              mpq.track('Search');
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
 *	jQuery carouFredSel 5.1.2
 *	Demo's and documentation:
 *	caroufredsel.frebsite.nl
 *	
 *	Copyright (c) 2011 Fred Heusschen
 *	www.frebsite.nl
 *
 *	Dual licensed under the MIT and GPL licenses.
 *	http://en.wikipedia.org/wiki/MIT_License
 *	http://en.wikipedia.org/wiki/GNU_General_Public_License
 */


eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(E($){7($.1M.1G)H;$.1M.1G=E(r,u){7(1a.Q==0){12(I,\'4S 3Z 5Y 1r "\'+1a.3z+\'".\');H 1a}7(1a.Q>1){H 1a.1O(E(){$(1a).1G(r,u)})}8 w=1a,$18=1a[0];7(w.1p(\'41\')){8 y=w.1x(\'4T\');w.S(\'4U\',I)}N{8 y=K}w.42=E(o,b,c){o=3A($18,o);7(o.12){D.12=o.12;12(D,\'5Z "12" 60 4V 4W 61 36 62 63 43-1e.\')}8 e=[\'9\',\'1c\',\'U\',\'X\',\'Z\',\'13\'];1r(8 a=0,l=e.Q;a<l;a++){o[e[a]]=3A($18,o[e[a]])}7(F o.1c==\'11\'){7(o.1c<=50)o.1c={\'9\':o.1c};N o.1c={\'1f\':o.1c}}N{7(F o.1c==\'1i\')o.1c={\'1y\':o.1c}}7(F o.9==\'11\')o.9={\'M\':o.9};N 7(o.9==\'15\')o.9={\'M\':o.9,\'O\':o.9,\'1n\':o.9};7(F o.9!=\'1e\')o.9={};7(b)2v=$.25(I,{},$.1M.1G.44,o);6=$.25(I,{},$.1M.1G.44,o);7(F 6.9.16!=\'1e\')6.9.16={};7(6.9.2w==0&&F c==\'11\'){6.9.2w=c}z.26=(6.26==\'45\'||6.26==\'1o\')?\'Z\':\'X\';8 f=[[\'O\',\'3B\',\'27\',\'1n\',\'4X\',\'2x\',\'1o\',\'2y\',\'1s\',0,1,2,3],[\'1n\',\'4X\',\'2x\',\'O\',\'3B\',\'27\',\'2y\',\'1o\',\'3C\',3,2,1,0]];8 g=f[0].Q,4Y=(6.26==\'2z\'||6.26==\'1o\')?0:1;6.d={};1r(8 d=0;d<g;d++){6.d[f[0][d]]=f[4Y][d]}8 h=w.T();7(6[6.d[\'O\']]==\'U\'){8 i=3D(h,6,\'27\');6[6.d[\'O\']]=i}7(6[6.d[\'1n\']]==\'U\'){8 i=3D(h,6,\'2x\');6[6.d[\'1n\']]=i}7(!6.9[6.d[\'O\']]){6.9[6.d[\'O\']]=(46(h,6,\'27\'))?\'15\':h[6.d[\'27\']](I)}7(!6.9[6.d[\'1n\']]){6.9[6.d[\'1n\']]=(46(h,6,\'2x\'))?\'15\':h[6.d[\'2x\']](I)}7(!6[6.d[\'1n\']]){6[6.d[\'1n\']]=6.9[6.d[\'1n\']]}7(F 6.9.M==\'1e\'){6.9.16.2J=6.9.M.2J;6.9.16.28=6.9.M.28;6.9.M=K}7(F 6.9.M==\'1i\'){6.9.16.3a=6.9.M;6.9.M=K}7(!6.9.M){7(6.9[6.d[\'O\']]==\'15\'){6.9.16.15=I}7(!6.9.16.15){7(F 6[6.d[\'O\']]==\'11\'){6.9.M=1H.3b(6[6.d[\'O\']]/6.9[6.d[\'O\']])}N{8 j=47($1E.3E(),6,\'3B\');6.9.M=1H.3b(j/6.9[6.d[\'O\']]);6[6.d[\'O\']]=6.9.M*6.9[6.d[\'O\']];7(!6.9.16.3a)6.1z=K}7(6.9.M==\'64\'||6.9.M<1){12(I,\'1U a 48 11 3c M 9: 65 36 "15".\');6.9.16.15=I}}}7(!6[6.d[\'O\']]){7(!6.9.16.15&&6.9[6.d[\'O\']]!=\'15\'){6[6.d[\'O\']]=6.9.M*6.9[6.d[\'O\']];6.1z=K}N{6[6.d[\'O\']]=\'15\'}}7(6.9.16.15){6.3F=(6[6.d[\'O\']]==\'15\')?47($1E.3E(),6,\'3B\'):6[6.d[\'O\']];7(6.1z===K){6[6.d[\'O\']]=\'15\'}6.9.M=2K(h,6,0);7(6.9.M>J.P){6.9.M=J.P}}7(F 6.1b==\'1A\'){6.1b=0}7(F 6.1z==\'1A\'){6.1z=(6[6.d[\'O\']]==\'15\')?K:\'4a\'}6.9.M=3G(6.9.M,6,6.9.16.3a);6.9.16.29=6.9.M;6.1j=K;6.1b=4Z(6.1b);7(6.1z==\'2y\')6.1z=\'1o\';7(6.1z==\'4b\')6.1z=\'2z\';1u(6.1z){R\'4a\':R\'1o\':R\'2z\':7(6[6.d[\'O\']]!=\'15\'){8 p=3H(2L(h,6),6);6.1j=I;6.1b[6.d[1]]=p[1];6.1b[6.d[3]]=p[0]}14;2A:6.1z=K;6.1j=(6.1b[0]==0&&6.1b[1]==0&&6.1b[2]==0&&6.1b[3]==0)?K:I;14}7(F 6.1P==\'1k\'&&6.1P)6.1P=\'66\'+w.67(\'68\');7(F 6.9.2M!=\'11\')6.9.2M=6.9.M;7(F 6.1c.1f!=\'11\')6.1c.1f=51;7(F 6.1c.9!=\'11\'){7(6.1c.9!=\'4c\'&&6.1c.9!=\'M\'){6.1c.9=(6.9.16.15)?\'15\':6.9.M}}6.U=3d($18,6.U,\'U\');6.X=3d($18,6.X);6.Z=3d($18,6.Z);6.13=3d($18,6.13,\'13\');6.U=$.25(I,{},6.1c,6.U);6.X=$.25(I,{},6.1c,6.X);6.Z=$.25(I,{},6.1c,6.Z);6.13=$.25(I,{},6.1c,6.13);7(F 6.13.3I!=\'1k\')6.13.3I=K;7(F 6.13.4d!=\'E\')6.13.4d=$.1M.1G.52;7(F 6.U.1B!=\'1k\')6.U.1B=I;7(F 6.U.4e!=\'11\')6.U.4e=0;7(F 6.U.2N!=\'11\')6.U.2N=(6.U.1f<10)?69:6.U.1f*5;7(6.1V){6.1V=4f(6.1V)}7(D.12){12(D,\'2O O: \'+6.O);12(D,\'2O 1n: \'+6.1n);7(6[6.d[\'O\']]==\'15\')12(D,\'6a \'+6.d[\'O\']+\': \'+6.3F);12(D,\'53 6b: \'+6.9.O);12(D,\'53 6c: \'+6.9.1n);12(D,\'3J 3c 9 M: \'+6.9.M);7(6.U.1B)12(D,\'3J 3c 9 4g 6d: \'+6.U.9);7(6.X.1d)12(D,\'3J 3c 9 4g 54: \'+6.X.9);7(6.Z.1d)12(D,\'3J 3c 9 4g 55: \'+6.Z.9)}};w.56=E(){w.1p(\'41\',I);7(w.V(\'2h\')==\'3K\'||w.V(\'2h\')==\'6e\'){12(D,\'6f 6g-6h "2h" 4V 4W "6i" 57 "59".\')}8 a={\'4h\':w.V(\'4h\'),\'2h\':w.V(\'2h\'),\'2y\':w.V(\'2y\'),\'2z\':w.V(\'2z\'),\'4b\':w.V(\'4b\'),\'1o\':w.V(\'1o\'),\'O\':w.V(\'O\'),\'1n\':w.V(\'1n\'),\'4i\':w.V(\'4i\'),\'1s\':w.V(\'1s\'),\'3C\':w.V(\'3C\'),\'4j\':w.V(\'4j\')};$1E.V(a).V({\'6j\':\'2P\',\'2h\':(a.2h==\'3K\')?\'3K\':\'59\'});w.1p(\'5a\',a).V({\'4h\':\'3L\',\'2h\':\'3K\',\'2y\':0,\'1o\':0,\'4i\':0,\'1s\':0,\'3C\':0,\'4j\':0});7(6.1j){w.T().1O(E(){8 m=2a($(1a).V(6.d[\'1s\']));7(2i(m))m=0;$(1a).1p(\'1I\',m)})}};w.5b=E(){w.4k();w.W(G(\'4l\',D),E(e,a){e.19();z.1W=I;7(6.U.1B){6.U.1B=K;w.S(G(\'2Q\',D),a)}H I});w.W(G(\'5c\',D),E(e){e.19();7(z.1J){3e(L)}H I});w.W(G(\'2Q\',D),E(e,a,b){e.19();1t=2R(1t);7(a&&z.1J){L.1W=I;8 c=2j()-L.2B;L.1f-=c;7(L.1g)L.1g.1f-=c;7(L.1F)L.1F.1f-=c;3e(L,K)}7(!z.2k&&!z.1J){7(b)1t.3f+=2j()-1t.2B}z.2k=I;7(6.U.5d){8 d=6.U.2N-1t.3f,3g=3M-1H.2S(d*3M/6.U.2N);6.U.5d.1v($18,3g,d)}H I});w.W(G(\'1B\',D),E(e,b,c,d){e.19();1t=2R(1t);8 v=[b,c,d],t=[\'1i\',\'11\',\'1k\'],a=2T(v,t);8 b=a[0],c=a[1],d=a[2];7(b!=\'X\'&&b!=\'Z\')b=z.26;7(F c!=\'11\')c=0;7(F d!=\'1k\')d=K;7(d){z.1W=K;6.U.1B=I}7(!6.U.1B){e.1Q();H 12(D,\'2O 5e: 1U 2C.\')}z.2k=K;1t.2B=2j();8 f=6.U.2N+c;3h=f-1t.3f;3g=3M-1H.2S(3h*3M/f);1t.U=6k(E(){7(6.U.5f){6.U.5f.1v($18,3g,3h)}7(z.1J){w.S(G(\'1B\',D),b)}N{w.S(G(b,D),6.U)}},3h);7(6.U.5g){6.U.5g.1v($18,3g,3h)}H I});w.W(G(\'2D\',D),E(e){e.19();7(L.1W){L.1W=K;z.2k=K;z.1J=I;L.2B=2j();1X(L)}N{w.S(G(\'1B\',D))}H I});w.W(G(\'X\',D)+\' \'+G(\'Z\',D),E(e,b,f,g){e.19();7(z.1W||w.5h(\':2P\')){e.1Q();H 12(D,\'2O 5e 57 2P: 1U 2C.\')}8 v=[b,f,g],t=[\'1e\',\'11/1i\',\'E\'],a=2T(v,t);8 b=a[0],f=a[1],g=a[2];8 h=e.4m.4n(D.2U.3i.Q);7(F b!=\'1e\'||b==2b)b=6[h];7(F g==\'E\')b.1R=g;7(F f!=\'11\'){8 i=[f,b.9,6[h].9];1r(8 a=0,l=i.Q;a<l;a++){7(F i[a]==\'11\'||i[a]==\'4c\'||i[a]==\'M\'){f=i[a];14}}7(f==\'4c\'){e.1Q();H w.1x(h+\'6l\',[b,g])}7(f==\'M\'){7(!6.9.16.15)f=6.9.M}}7(L.1W){w.S(G(\'2D\',D));w.S(G(\'2V\',D),[h,[b,f,g]]);e.1Q();H 12(D,\'2O 6m 2C.\')}7(6.9.2M>=J.P){e.1Q();H 12(D,\'1U 5i 9 (\'+J.P+\', \'+6.9.2M+\' 5j): 1U 2C.\')}7(b.1f>0){7(z.1J){7(b.2V)w.S(G(\'2V\',D),[h,[b,f,g]]);e.1Q();H 12(D,\'2O 6n 2C.\')}}7(b.4o&&!b.4o.1v($18)){e.1Q();H 12(D,\'6o "4o" 6p K.\')}1t.3f=0;w.S(\'5k\'+h,[b,f]);7(6.1V){8 s=6.1V,c=[b,f];1r(8 j=0,l=s.Q;j<l;j++){8 d=h;7(!s[j][1])c[0]=s[j][0].1x(\'5l\',h);7(!s[j][2])d=(d==\'X\')?\'Z\':\'X\';c[1]=f+s[j][3];s[j][0].S(\'5k\'+d,c)}}H I});w.W(G(\'6q\',D,K),E(e,f,g){e.19();8 h=w.T();7(!6.1S){7(J.Y==0){7(6.2W){w.S(G(\'Z\',D),J.P-1)}H e.1Q()}}7(6.1j)1C(h,6);7(F g!=\'11\'){7(6.9.16.15){g=4p(h,6,J.P-1)}N{g=6.9.M}}7(!6.1S){7(J.P-g<J.Y){g=J.P-J.Y}}7(6.9.16.15){8 i=2K(h,6,J.P-g);7(6.9.M+g<=i&&g<J.P){g++;i=2K(h,6,J.P-g)}6.9.16.29=6.9.M;6.9.M=3G(i,6,6.9.16.3a)}7(6.1j)1C(h,6,I);7(g==0){e.1Q();H 12(D,\'0 9 36 1c: 1U 2C.\')}12(D,\'5m \'+g+\' 9 54.\');J.Y+=g;2l(J.Y>=J.P)J.Y-=J.P;7(!6.1S){7(J.Y==0&&f.3N)f.3N.1v($18);7(!6.2W)2E(6,J.Y)}w.T().1l(J.P-g).6r(w);7(J.P<6.9.M+g){w.T().1l(0,(6.9.M+g)-J.P).3O(I).3j(w)}8 h=w.T(),2c=5n(h,6,g),1K=5o(h,6),2d=h.1Y(g-1),1Z=2c.2F(),2e=1K.2F();7(6.1j)1C(h,6);7(6.1z)8 p=3H(1K,6);7(f.1w==\'5p\'&&6.9.M<g){8 j=h.1l(6.9.16.29,g).3k(),3P=6.9[6.d[\'O\']];6.9[6.d[\'O\']]=\'15\'}N{8 j=K}8 k=2X(h.1l(0,g),6,\'O\'),20=3Q(2m(1K,6,I),6,!6.1j);7(j)6.9[6.d[\'O\']]=3P;7(6.1j){1C(h,6,I);1C(1Z,6,6.1b[6.d[1]]);1C(2d,6,6.1b[6.d[3]])}7(6.1z){6.1b[6.d[1]]=p[1];6.1b[6.d[3]]=p[0]}8 l={},4q={},2Y={},2Z={},1m=f.1f;7(f.1w==\'3L\')1m=0;N 7(1m==\'U\')1m=6.1c.1f/6.1c.9*g;N 7(1m<=0)1m=0;N 7(1m<10)1m=k/1m;L=1T(1m,f.1y);7(6[6.d[\'O\']]==\'15\'||6[6.d[\'1n\']]==\'15\'){L.17.1h([$1E,20])}7(6.1j){8 m=6.1b[6.d[3]];2Y[6.d[\'1s\']]=2d.1p(\'1I\');4q[6.d[\'1s\']]=2e.1p(\'1I\')+6.1b[6.d[1]];2Z[6.d[\'1s\']]=1Z.1p(\'1I\');7(2e.4r(2d).Q){L.17.1h([2d,2Y])}7(2e.4r(1Z).Q){L.17.1h([1Z,2Z])}L.17.1h([2e,4q])}N{8 m=0}l[6.d[\'1o\']]=m;8 n=[2c,1K,20,1m];7(f.21)f.21.3l($18,n);1N.21=3m(1N.21,$18,n);1u(f.1w){R\'2n\':R\'22\':R\'2o\':R\'23\':L.1g=1T(L.1f,L.1y);L.1F=1T(L.1f,L.1y);L.1f=0;14}1u(f.1w){R\'22\':R\'2o\':R\'23\':8 o=w.3O().3j($1E);14}1u(f.1w){R\'23\':o.T().1l(0,g).1D();R\'22\':R\'2o\':o.T().1l(6.9.M).1D();14}1u(f.1w){R\'2n\':L.1g.17.1h([w,{\'24\':0}]);14;R\'22\':o.V({\'24\':0});L.1g.17.1h([w,{\'O\':\'+=0\'},E(){o.1D()}]);L.1F.17.1h([o,{\'24\':1}]);14;R\'2o\':L=4s(L,w,o,6,I);14;R\'23\':L=4t(L,w,o,6,I,g);14}8 q=E(){8 b=6.9.M+g-J.P;7(b>0){w.T().1l(J.P).1D();2c=w.T().1l(J.P-(g-b)).5q().6s(w.T().1l(0,b).5q())}7(j)j.3n();7(6.1j){8 c=w.T().1Y(6.9.M+g-1);c.V(6.d[\'1s\'],c.1p(\'1I\'))}L.17=[];7(L.1g)L.1g=1T(L.4u,L.1y);8 d=E(){1u(f.1w){R\'2n\':R\'22\':w.V(\'5r\',\'\');14}L.1F=1T(0,2b);z.1J=K;8 a=[2c,1K,20];7(f.1R)f.1R.3l($18,a);1N.1R=3m(1N.1R,$18,a);7(1L.Q){w.S(G(1L[0][0],D),1L[0][1]);1L.5s()}7(!z.2k)w.S(G(\'1B\',D))};1u(f.1w){R\'2n\':L.1g.17.1h([w,{\'24\':1},d]);1X(L.1g);14;R\'23\':L.1g.17.1h([w,{\'O\':\'+=0\'},d]);1X(L.1g);14;2A:d();14}};L.17.1h([w,l,q]);z.1J=I;w.V(6.d[\'1o\'],-k);1t=2R(1t);1X(L);4v(6.1P,w.1x(G(\'3o\',D)));w.S(G(\'2G\',D),[K,20]);H I});w.W(G(\'6t\',D,K),E(e,f,g){e.19();8 h=w.T();7(!6.1S){7(J.Y==6.9.M){7(6.2W){w.S(G(\'X\',D),J.P-1)}H e.1Q()}}7(6.1j)1C(h,6);7(F g!=\'11\'){g=6.9.M}8 i=(J.Y==0)?J.P:J.Y;7(!6.1S){7(6.9.16.15){8 j=2K(h,6,g),4w=4p(h,6,i-1)}N{8 j=6.9.M,4w=6.9.M}7(g+j>i){g=i-4w}}7(6.9.16.15){8 j=4x(h,6,g,i);2l(6.9.M-g>=j&&g<J.P){g++;j=4x(h,6,g,i)}6.9.16.29=6.9.M;6.9.M=3G(j,6,6.9.16.3a)}7(6.1j)1C(h,6,I);7(g==0){e.1Q();H 12(D,\'0 9 36 1c: 1U 2C.\')}12(D,\'5m \'+g+\' 9 55.\');J.Y-=g;2l(J.Y<0)J.Y+=J.P;7(!6.1S){7(J.Y==6.9.M&&f.3N)f.3N.1v($18);7(!6.2W)2E(6,J.Y)}7(J.P<6.9.M+g){w.T().1l(0,(6.9.M+g)-J.P).3O(I).3j(w)}8 h=w.T(),2c=4y(h,6),1K=4z(h,6,g),2d=h.1Y(g-1),1Z=2c.2F(),2e=1K.2F();7(6.1j)1C(h,6);7(6.1z)8 p=3H(1K,6);7(f.1w==\'5p\'&&6.9.16.29<g){8 k=h.1l(6.9.16.29,g).3k(),3P=6.9[6.d[\'O\']];6.9[6.d[\'O\']]=\'15\'}N{8 k=K}8 l=2X(h.1l(0,g),6,\'O\'),20=3Q(2m(1K,6,I),6,!6.1j);7(k)6.9[6.d[\'O\']]=3P;7(6.1j){1C(h,6,I);1C(1Z,6,6.1b[6.d[1]]);1C(2e,6,6.1b[6.d[1]])}7(6.1z){6.1b[6.d[1]]=p[1];6.1b[6.d[3]]=p[0]}8 m={},2Z={},2Y={},1m=f.1f;7(f.1w==\'3L\')1m=0;N 7(1m==\'U\')1m=6.1c.1f/6.1c.9*g;N 7(1m<=0)1m=0;N 7(1m<10)1m=l/1m;L=1T(1m,f.1y);7(6[6.d[\'O\']]==\'15\'||6[6.d[\'1n\']]==\'15\'){L.17.1h([$1E,20])}7(6.1j){2Z[6.d[\'1s\']]=1Z.1p(\'1I\');2Y[6.d[\'1s\']]=2d.1p(\'1I\')+6.1b[6.d[3]];2e.V(6.d[\'1s\'],2e.1p(\'1I\')+6.1b[6.d[1]]);7(2d.4r(1Z).Q){L.17.1h([1Z,2Z])}L.17.1h([2d,2Y])}m[6.d[\'1o\']]=-l;8 n=[2c,1K,20,1m];7(f.21)f.21.3l($18,n);1N.21=3m(1N.21,$18,n);1u(f.1w){R\'2n\':R\'22\':R\'2o\':R\'23\':L.1g=1T(L.1f,L.1y);L.1F=1T(L.1f,L.1y);L.1f=0;14}1u(f.1w){R\'22\':R\'2o\':R\'23\':8 o=w.3O().3j($1E);14}1u(f.1w){R\'23\':o.T().1l(6.9.16.29).1D();14;R\'22\':R\'2o\':o.T().1l(0,g).1D();o.T().1l(6.9.M).1D();14}1u(f.1w){R\'2n\':L.1g.17.1h([w,{\'24\':0}]);14;R\'22\':o.V({\'24\':0});L.1g.17.1h([w,{\'O\':\'+=0\'},E(){o.1D()}]);L.1F.17.1h([o,{\'24\':1}]);14;R\'2o\':L=4s(L,w,o,6,K);14;R\'23\':L=4t(L,w,o,6,K,g);14}8 q=E(){8 b=6.9.M+g-J.P,5t=(6.1j)?6.1b[6.d[3]]:0;w.V(6.d[\'1o\'],5t);7(b>0){w.T().1l(J.P).1D()}8 c=w.T().1l(0,g).3j(w).2F();7(b>0){1K=2L(h,6)}7(k)k.3n();7(6.1j){7(J.P<6.9.M+g){8 d=w.T().1Y(6.9.M-1);d.V(6.d[\'1s\'],d.1p(\'1I\')+6.1b[6.d[3]])}c.V(6.d[\'1s\'],c.1p(\'1I\'))}L.17=[];7(L.1g)L.1g=1T(L.4u,L.1y);8 e=E(){1u(f.1w){R\'2n\':R\'22\':w.V(\'5r\',\'\');14}L.1F=1T(0,2b);z.1J=K;8 a=[2c,1K,20];7(f.1R)f.1R.3l($18,a);1N.1R=3m(1N.1R,$18,a);7(1L.Q){w.S(G(1L[0][0],D),1L[0][1]);1L.5s()}7(!z.2k)w.S(G(\'1B\',D))};1u(f.1w){R\'2n\':L.1g.17.1h([w,{\'24\':1},e]);1X(L.1g);14;R\'23\':L.1g.17.1h([w,{\'O\':\'+=0\'},e]);1X(L.1g);14;2A:e();14}};L.17.1h([w,m,q]);z.1J=I;1t=2R(1t);1X(L);4v(6.1P,w.1x(G(\'3o\',D)));w.S(G(\'2G\',D),[K,20]);H I});w.W(G(\'2H\',D),E(e,b,c,d,f,g,h){e.19();8 v=[b,c,d,f,g,h],t=[\'1i/11/1e\',\'11\',\'1k\',\'1e\',\'1i\',\'E\'],a=2T(v,t);8 f=a[3],g=a[4],h=a[5];b=31(a[0],a[1],a[2],J,w);7(b==0)H;7(F f!=\'1e\')f=K;7(z.1J){7(F f!=\'1e\'||f.1f>0)H K}7(g!=\'X\'&&g!=\'Z\'){7(6.1S){7(b<=J.P/2)g=\'Z\';N g=\'X\'}N{7(J.Y==0||J.Y>b)g=\'Z\';N g=\'X\'}}7(g==\'X\')b=J.P-b;w.S(G(g,D),[f,b,h]);H I});w.W(G(\'6u\',D),E(e,a,b){e.19();8 c=w.1x(G(\'3p\',D));H w.1x(G(\'4A\',D),[c-1,a,\'X\',b])});w.W(G(\'6v\',D),E(e,a,b){e.19();8 c=w.1x(G(\'3p\',D));H w.1x(G(\'4A\',D),[c+1,a,\'Z\',b])});w.W(G(\'4A\',D),E(e,a,b,c,d){e.19();7(F a!=\'11\')a=w.1x(G(\'3p\',D));8 f=6.13.9||6.9.M,28=1H.3b(J.P/f);7(a<0)a=28;7(a>28)a=0;H w.1x(G(\'2H\',D),[a*f,0,I,b,c,d])});w.W(G(\'5u\',D),E(e,s){e.19();7(s)s=31(s,0,I,J,w);N s=0;s+=J.Y;7(s!=0){2l(s>J.P)s-=J.P;w.6w(w.T().1l(s))}H I});w.W(G(\'1V\',D),E(e,s){e.19();7(s)s=4f(s);N 7(6.1V)s=6.1V;N H 12(D,\'4S 6x 36 1V.\');8 n=w.1x(G(\'3o\',D)),x=I;1r(8 j=0,l=s.Q;j<l;j++){7(!s[j][0].1x(G(\'2H\',D),[n,s[j][3],I])){x=K}}H x});w.W(G(\'2V\',D),E(e,a,b){e.19();7(F a==\'E\'){a.1v($18,1L)}N 7(32(a)){1L=a}N 7(F a!=\'1A\'){1L.1h([a,b])}H 1L});w.W(G(\'6y\',D),E(e,b,c,d,f){e.19();8 v=[b,c,d,f],t=[\'1i/1e\',\'1i/11/1e\',\'1k\',\'11\'],a=2T(v,t);8 b=a[0],c=a[1],d=a[2],f=a[3];7(F b==\'1e\'&&F b.3q==\'1A\')b=$(b);7(F b==\'1i\')b=$(b);7(F b!=\'1e\'||F b.3q==\'1A\'||b.Q==0)H 12(D,\'1U a 48 1e.\');7(F c==\'1A\')c=\'3R\';7(6.1j){b.1O(E(){8 m=2a($(1a).V(6.d[\'1s\']));7(2i(m))m=0;$(1a).1p(\'1I\',m)})}8 g=c,3r=\'3r\';7(c==\'3R\'){7(d){7(J.Y==0){c=J.P-1;3r=\'5v\'}N{c=J.Y;J.Y+=b.Q}7(c<0)c=0}N{c=J.P-1;3r=\'5v\'}}N{c=31(c,f,d,J,w)}7(g!=\'3R\'&&!d){7(c<J.Y)J.Y+=b.Q}7(J.Y>=J.P)J.Y-=J.P;8 h=w.T().1Y(c);7(h.Q){h[3r](b)}N{w.5w(b)}J.P=w.T().Q;8 i=3s(w,6);3t(6,J.P,D);2E(6,J.Y);w.S(G(\'4B\',D));w.S(G(\'2G\',D),[I,i]);H I});w.W(G(\'6z\',D),E(e,b,c,d){e.19();8 v=[b,c,d],t=[\'1i/11/1e\',\'1k\',\'11\'],a=2T(v,t);8 b=a[0],c=a[1],d=a[2];7(F b==\'1A\'||b==\'3R\'){w.T().2F().1D()}N{b=31(b,d,c,J,w);8 f=w.T().1Y(b);7(f.Q){7(b<J.Y)J.Y-=f.Q;f.1D()}}J.P=w.T().Q;8 g=3s(w,6);3t(6,J.P,D);2E(6,J.Y);w.S(G(\'2G\',D),[I,g]);H I});w.W(G(\'21\',D)+\' \'+G(\'1R\',D),E(e,a){e.19();8 b=e.4m.4n(D.2U.3i.Q);7(32(a))1N[b]=a;7(F a==\'E\')1N[b].1h(a);H 1N[b]});w.W(G(\'4T\',D,K),E(e,a){e.19();H w.1x(G(\'3o\',D),a)});w.W(G(\'3o\',D),E(e,a){e.19();7(J.Y==0)8 b=0;N 8 b=J.P-J.Y;7(F a==\'E\')a.1v($18,b);H b});w.W(G(\'3p\',D),E(e,a){e.19();8 b=6.13.9||6.9.M;8 c=1H.2S(J.P/b-1);7(J.Y==0)8 d=0;N 7(J.Y<J.P%b)8 d=0;N 7(J.Y==b&&!6.1S)8 d=c;N 8 d=1H.6A((J.P-J.Y)/b);7(d<0)d=0;7(d>c)d=c;7(F a==\'E\')a.1v($18,d);H d});w.W(G(\'6B\',D),E(e,a){e.19();$i=2L(w.T(),6);7(F a==\'E\')a.1v($18,$i);H $i});w.W(G(\'2k\',D)+\' \'+G(\'1W\',D)+\' \'+G(\'1J\',D),E(e,a){e.19();8 b=e.4m.4n(D.2U.3i.Q);7(F a==\'E\')a.1v($18,z[b]);H z[b]});w.W(G(\'5l\',D,K),E(e,a,b,c){e.19();H w.1x(G(\'43\',D),[a,b,c])});w.W(G(\'43\',D),E(e,a,b,c){e.19();8 d=K;7(F a==\'E\'){a.1v($18,6)}N 7(F a==\'1e\'){2v=$.25(I,{},2v,a);7(b!==K)d=I;N 6=$.25(I,{},6,a)}N 7(F a!=\'1A\'){7(F b==\'E\'){8 f=3S(\'6.\'+a);7(F f==\'1A\')f=\'\';b.1v($18,f)}N 7(F b!=\'1A\'){7(F c!==\'1k\')c=I;3S(\'2v.\'+a+\' = b\');7(c!==K)d=I;N 3S(\'6.\'+a+\' = b\')}N{H 3S(\'6.\'+a)}}7(d){1C(w.T(),6);w.42(2v);w.4C();8 g=3s(w,6);w.S(G(\'2G\',D),[I,g])}H 6});w.W(G(\'4B\',D),E(e,a,b){e.19();7(F a==\'1A\'||a.Q==0)a=$(\'6C\');N 7(F a==\'1i\')a=$(a);7(F a!=\'1e\')H 12(D,\'1U a 48 1e.\');7(F b!=\'1i\'||b.Q==0)b=\'a.5x\';a.6D(b).1O(E(){8 h=1a.5y||\'\';7(h.Q>0&&w.T().5z($(h))!=-1){$(1a).2p(\'4D\').4D(E(e){e.2f();w.S(G(\'2H\',D),h)})}});H I});w.W(G(\'2G\',D),E(e,b,c){e.19();7(!6.13.1q)H;7(F b==\'1k\'&&b){6.13.1q.T().1D();8 d=6.13.9||6.9.M;1r(8 a=0,l=1H.2S(J.P/d);a<l;a++){8 i=w.T().1Y(31(a*d,0,I,J,w));6.13.1q.5w(6.13.4d(a+1,i))}6.13.1q.1O(E(){$(1a).T().2p(6.13.3u).1O(E(a){$(1a).W(6.13.3u,E(e){e.2f();w.S(G(\'2H\',D),[a*d,0,I,6.13])})})})}6.13.1q.1O(E(){$(1a).T().33(\'5A\').1Y(w.1x(G(\'3p\',D))).3v(\'5A\')});H I});w.W(G(\'4U\',D,K),E(e,a){e.19();w.S(G(\'5B\',D),a);H I});w.W(G(\'5B\',D),E(e,a){e.19();1t=2R(1t);w.1p(\'41\',K);w.S(G(\'5c\',D));7(a){w.S(G(\'5u\',D))}7(6.1j){1C(w.T(),6)}w.V(w.1p(\'5a\'));w.4k();w.4E();$1E.6E(w);H I})};w.4k=E(){w.2p(G(\'\',D,K))};w.4C=E(){w.4E();3t(6,J.P,D);2E(6,J.Y);7(6.U.2g){8 c=3w(6.U.2g);$1E.W(G(\'3T\',D,K),E(){w.S(G(\'2Q\',D),[c[0],c[1]])}).W(G(\'3U\',D,K),E(){w.S(G(\'2D\',D))})}7(6.X.1d){6.X.1d.W(G(6.X.3u,D,K),E(e){e.2f();w.S(G(\'X\',D))});7(6.X.2g){8 c=3w(6.X.2g);6.X.1d.W(G(\'3T\',D,K),E(){w.S(G(\'2Q\',D),[c[0],c[1]])}).W(G(\'3U\',D,K),E(){w.S(G(\'2D\',D))})}}7(6.Z.1d){6.Z.1d.W(G(6.Z.3u,D,K),E(e){e.2f();w.S(G(\'Z\',D))});7(6.Z.2g){8 c=3w(6.Z.2g);6.Z.1d.W(G(\'3T\',D,K),E(){w.S(G(\'2Q\',D),[c[0],c[1]])}).W(G(\'3U\',D,K),E(){w.S(G(\'2D\',D))})}}7($.1M.2q){7(6.X.2q){7(!z.4F){z.4F=I;$1E.2q(E(e,a){7(a>0){e.2f();8 b=4G(6.X.2q);w.S(G(\'X\',D),b)}})}}7(6.Z.2q){7(!z.4H){z.4H=I;$1E.2q(E(e,a){7(a<0){e.2f();8 b=4G(6.Z.2q);w.S(G(\'Z\',D),b)}})}}}7($.1M.3x){8 d=(6.X.4I)?E(){w.S(G(\'X\',D))}:2b,3y=(6.Z.4I)?E(){w.S(G(\'Z\',D))}:2b;7(3y||3y){7(!z.3x){z.3x=I;8 f={\'6F\':30,\'6G\':30,\'6H\':I};1u(6.26){R\'45\':R\'5C\':f.6I=3y;f.6J=d;14;2A:f.6K=3y;f.6L=d}$1E.3x(f)}}}7(6.13.1q){7(6.13.2g){8 c=3w(6.13.2g);6.13.1q.W(G(\'3T\',D,K),E(){w.S(G(\'2Q\',D),[c[0],c[1]])}).W(G(\'3U\',D,K),E(){w.S(G(\'2D\',D))})}}7(6.X.2r||6.Z.2r){$(34).W(G(\'5D\',D,K),E(e){8 k=e.5E;7(k==6.Z.2r){e.2f();w.S(G(\'Z\',D))}7(k==6.X.2r){e.2f();w.S(G(\'X\',D))}})}7(6.13.3I){$(34).W(G(\'5D\',D,K),E(e){8 k=e.5E;7(k>=49&&k<58){k=(k-49)*6.9.M;7(k<=J.P){e.2f();w.S(G(\'2H\',D),[k,0,I,6.13])}}})}7(6.U.1B){w.S(G(\'1B\',D),6.U.4e)}};w.4E=E(){$(34).2p(G(\'\',D,K));$1E.2p(G(\'\',D,K));7(6.X.1d)6.X.1d.2p(G(\'\',D,K));7(6.Z.1d)6.Z.1d.2p(G(\'\',D,K));7(6.13.1q)6.13.1q.2p(G(\'\',D,K));3t(6,\'3k\',D);2E(6,\'33\');7(6.13.1q){6.13.1q.T().1D()}};8 z={\'26\':\'Z\',\'2k\':I,\'1J\':K,\'1W\':K,\'4H\':K,\'4F\':K,\'3x\':K},J={\'P\':w.T().Q,\'Y\':0},1t={\'6M\':2b,\'U\':2b,\'2V\':2b,\'2B\':2j(),\'3f\':0},L={\'1W\':K,\'1f\':0,\'2B\':0,\'1y\':\'\',\'17\':[]},1N={\'21\':[],\'1R\':[]},1L=[],D=$.25(I,{},$.1M.1G.5F,u),6={},2v=r,$1E=w.6N(\'<\'+D.4J.3Z+\' 6O="\'+D.4J.5G+\'" />\').3E();D.3z=w.3z;w.42(2v,I,y);w.56();w.5b();w.4C();7(6.1P){6.9.2w=5H(6.1P);8 A=6.1P+\'=\';8 B=34.1P.2I(\';\');1r(8 a=0,l=B.Q;a<l;a++){8 c=B[a];2l(c.5I(0)==\' \'){c=c.3V(1,c.Q)}7(c.2s(A)==0){6.9.2w=c.3V(A.Q,c.Q);14}}}7(6.9.2w!=0){8 s=6.9.2w;7(s===I){s=3W.6P.5y;7(!s.Q)s=0}N 7(s===\'5J\'){s=1H.3b(1H.5J()*J.P)}w.S(G(\'2H\',D),[s,0,I,{1w:\'3L\'}])}8 C=3s(w,6,K),5K=2L(w.T(),6);7(6.5L){6.5L.1v($18,5K,C)}w.S(G(\'2G\',D),[I,C]);w.S(G(\'4B\',D));H w};$.1M.1G.44={\'1V\':K,\'2W\':I,\'1S\':I,\'26\':\'1o\',\'9\':{\'2w\':0},\'1c\':{\'1y\':\'6Q\',\'1f\':51,\'2g\':K,\'2q\':K,\'4I\':K,\'3u\':\'4D\',\'2V\':K}};$.1M.1G.5F={\'12\':K,\'2U\':{\'3i\':\'\',\'5M\':\'6R\'},\'4J\':{\'3Z\':\'6S\',\'5G\':\'6T\'}};$.1M.1G.52=E(a,b){H\'<a 6U="#"><5N>\'+a+\'</5N></a>\'};E 1T(d,e){H{17:[],1f:d,4u:d,1y:e,2B:2j()}}E 1X(s){7(F s.1g==\'1e\'){1X(s.1g)}1r(8 a=0,l=s.17.Q;a<l;a++){8 b=s.17[a];7(!b)6V;7(b[3])b[0].4l();b[0].5O(b[1],{5P:b[2],1f:s.1f,1y:s.1y})}7(F s.1F==\'1e\'){1X(s.1F)}}E 3e(s,c){7(F c!=\'1k\')c=I;7(F s.1g==\'1e\'){3e(s.1g,c)}1r(8 a=0,l=s.17.Q;a<l;a++){8 b=s.17[a];b[0].4l(I);7(c){b[0].V(b[1]);7(F b[2]==\'E\')b[2]()}}7(F s.1F==\'1e\'){3e(s.1F,c)}}E 2R(t){7(t.U)6W(t.U);H t}E 3m(b,t,c){7(b.Q){1r(8 a=0,l=b.Q;a<l;a++){b[a].3l(t,c)}}H[]}E 6X(a,c,x,d,f){8 o={\'1f\':d,\'1y\':a.1y};7(F f==\'E\')o.5P=f;c.5O({24:x},o)}E 4s(a,b,c,o,d){8 e=2m(4y(b.T(),o),o,I)[0],4K=2m(c.T(),o,I)[0],3X=(d)?-4K:e,2t={},35={};2t[o.d[\'O\']]=4K;2t[o.d[\'1o\']]=3X;35[o.d[\'1o\']]=0;a.1g.17.1h([b,{\'24\':1}]);a.1F.17.1h([c,35,E(){$(1a).1D()}]);c.V(2t);H a}E 4t(a,b,c,o,d,n){8 e=2m(4z(b.T(),o,n),o,I)[0],4L=2m(c.T(),o,I)[0],3X=(d)?-4L:e,2t={},35={};2t[o.d[\'O\']]=4L;2t[o.d[\'1o\']]=0;35[o.d[\'1o\']]=3X;a.1F.17.1h([c,35,E(){$(1a).1D()}]);c.V(2t);H a}E 3t(o,t,c){7(t==\'3n\'||t==\'3k\'){8 f=t}N 7(o.9.2M>=t){12(c,\'1U 5i 9: 6Y 6Z (\'+t+\' 9, \'+o.9.2M+\' 5j).\');8 f=\'3k\'}N{8 f=\'3n\'}8 s=(f==\'3n\')?\'33\':\'3v\';7(o.X.1d)o.X.1d[f]()[s](\'2P\');7(o.Z.1d)o.Z.1d[f]()[s](\'2P\');7(o.13.1q)o.13.1q[f]()[s](\'2P\')}E 2E(o,f){7(o.1S||o.2W)H;8 a=(f==\'33\'||f==\'3v\')?f:K;7(o.Z.1d){8 b=a||(f==o.9.M)?\'3v\':\'33\';o.Z.1d[b](\'5Q\')}7(o.X.1d){8 b=a||(f==0)?\'3v\':\'33\';o.X.1d[b](\'5Q\')}}E 3A(a,b){7(F b==\'E\')b=b.1v(a);7(F b==\'1A\')b={};H b}E 3d(a,b,c){7(F c!=\'1i\')c=\'\';b=3A(a,b);7(F b==\'1i\'){8 d=4M(b);7(d==-1)b=$(b);N b=d}7(c==\'13\'){7(F b==\'1k\')b={\'3I\':b};7(F b.3q!=\'1A\')b={\'1q\':b};7(F b.1q==\'E\')b.1q=b.1q.1v(a);7(F b.1q==\'1i\')b.1q=$(b.1q);7(F b.9!=\'11\')b.9=K}N 7(c==\'U\'){7(F b==\'1k\')b={\'1B\':b};7(F b==\'11\')b={\'2N\':b}}N{7(F b.3q!=\'1A\')b={\'1d\':b};7(F b==\'11\')b={\'2r\':b};7(F b.1d==\'E\')b.1d=b.1d.1v(a);7(F b.1d==\'1i\')b.1d=$(b.1d);7(F b.2r==\'1i\')b.2r=4M(b.2r)}H b}E 31(a,b,c,d,e){7(F a==\'1i\'){7(2i(a))a=$(a);N a=2a(a)}7(F a==\'1e\'){7(F a.3q==\'1A\')a=$(a);a=e.T().5z(a);7(a==-1)a=0;7(F c!=\'1k\')c=K}N{7(F c!=\'1k\')c=I}7(2i(a))a=0;N a=2a(a);7(2i(b))b=0;N b=2a(b);7(c){a+=d.Y}a+=b;7(d.P>0){2l(a>=d.P){a-=d.P}2l(a<0){a+=d.P}}H a}E 4p(i,o,s){8 t=0,x=0;1r(8 a=s;a>=0;a--){t+=i.1Y(a)[o.d[\'27\']](I);7(t>o.3F)H x;7(a==0)a=i.Q;x++}}E 2K(i,o,s){8 t=0,x=0;1r(8 a=s,l=i.Q-1;a<=l;a++){t+=i.1Y(a)[o.d[\'27\']](I);7(t>o.3F)H x;7(a==l)a=-1;x++}}E 4x(i,o,s,l){8 v=2K(i,o,s);7(!o.1S){7(s+v>l)v=l-s}H v}E 2L(i,o){H i.1l(0,o.9.M)}E 5n(i,o,n){H i.1l(n,o.9.16.29+n)}E 5o(i,o){H i.1l(0,o.9.M)}E 4y(i,o){H i.1l(0,o.9.16.29)}E 4z(i,o,n){H i.1l(n,o.9.M+n)}E 1C(i,o,m){8 x=(F m==\'1k\')?m:K;7(F m!=\'11\')m=0;i.1O(E(){8 t=2a($(1a).V(o.d[\'1s\']));7(2i(t))t=0;$(1a).1p(\'5R\',t);$(1a).V(o.d[\'1s\'],((x)?$(1a).1p(\'5R\'):m+$(1a).1p(\'1I\')))})}E 3s(a,o,p){8 b=a.3E(),$i=a.T(),$v=2L($i,o),3Y=3Q(2m($v,o,I),o,p);b.V(3Y);7(o.1j){8 c=$v.2F();c.V(o.d[\'1s\'],c.1p(\'1I\')+o.1b[o.d[1]]);a.V(o.d[\'2y\'],o.1b[o.d[0]]);a.V(o.d[\'1o\'],o.1b[o.d[3]])}a.V(o.d[\'O\'],3Y[o.d[\'O\']]+(2X($i,o,\'O\')*2));a.V(o.d[\'1n\'],4N($i,o,\'1n\'));H 3Y}E 2m(i,o,a){5S=2X(i,o,\'O\',a);5T=4N(i,o,\'1n\',a);H[5S,5T]}E 4N(i,o,a,b){7(F b!=\'1k\')b=K;7(F o[o.d[a]]==\'11\'&&b)H o[o.d[a]];7(F o.9[o.d[a]]==\'11\')H o.9[o.d[a]];8 c=(a.4O().2s(\'O\')>-1)?\'27\':\'2x\';H 3D(i,o,c)}E 3D(i,o,a){8 s=0;i.1O(E(){8 m=$(1a)[o.d[a]](I);7(s<m)s=m});H s}E 47(b,o,c){8 d=b[o.d[c]](),4P=(o.d[c].4O().2s(\'O\')>-1)?[\'70\',\'71\']:[\'72\',\'73\'];1r(a=0,l=4P.Q;a<l;a++){8 m=2a(b.V(4P[a]));7(2i(m))m=0;d-=m}H d}E 2X(i,o,a,b){7(F b!=\'1k\')b=K;7(F o[o.d[a]]==\'11\'&&b)H o[o.d[a]];7(F o.9[o.d[a]]==\'11\')H o.9[o.d[a]]*i.Q;8 d=(a.4O().2s(\'O\')>-1)?\'27\':\'2x\',s=0;i.1O(E(){8 j=$(1a);7(j.5h(\':M\')){s+=j[o.d[d]](I)}});H s}E 46(i,o,a){8 s=K,v=K;i.1O(E(){c=$(1a)[o.d[a]](I);7(s===K)s=c;N 7(s!=c)v=I;7(s==0)v=I});H v}E G(n,c,a,b){7(F a!=\'1k\')a=I;7(F b!=\'1k\')b=I;7(a)n=c.2U.3i+n;7(b)n=n+\'.\'+c.2U.5M;H n}E 3Q(a,o,p){7(F p!=\'1k\')p=I;8 b=(o.1j&&p)?o.1b:[0,0,0,0];8 c={};c[o.d[\'O\']]=a[0]+b[1]+b[3];c[o.d[\'1n\']]=a[1]+b[0]+b[2];H c}E 2T(c,d){8 e=[];1r(8 a=0,5U=c.Q;a<5U;a++){1r(8 b=0,5V=d.Q;b<5V;b++){7(d[b].2s(F c[a])>-1&&!e[b]){e[b]=c[a];14}}}H e}E 4Z(p){7(F p==\'1A\')H[0,0,0,0];7(F p==\'11\')H[p,p,p,p];N 7(F p==\'1i\')p=p.2I(\'74\').5W(\'\').2I(\'75\').5W(\'\').2I(\' \');7(!32(p)){H[0,0,0,0]}1r(8 i=0;i<4;i++){p[i]=2a(p[i])}1u(p.Q){R 0:H[0,0,0,0];R 1:H[p[0],p[0],p[0],p[0]];R 2:H[p[0],p[1],p[0],p[1]];R 3:H[p[0],p[1],p[2],p[1]];2A:H[p[0],p[1],p[2],p[3]]}}E 3H(a,o){8 x=(F o[o.d[\'O\']]==\'11\')?1H.2S(o[o.d[\'O\']]-2X(a,o,\'O\')):0;1u(o.1z){R\'1o\':H[0,x];R\'2z\':H[x,0];R\'4a\':2A:H[1H.2S(x/2),1H.3b(x/2)]}}E 3G(x,o,a){8 v=x;7(F a==\'1i\'){8 p=a.2I(\'+\'),m=a.2I(\'-\');7(m.Q>p.Q){8 b=I,4Q=m[0],2u=m[1]}N{8 b=K,4Q=p[0],2u=p[1]}1u(4Q){R\'76\':v=(x%2==1)?x-1:x;14;R\'77\':v=(x%2==0)?x-1:x;14;2A:v=x;14}2u=2a(2u);7(!2i(2u)){7(b)2u=-2u;v+=2u}}8 i=o.9.16;7(i.2J||i.28){7(F i.2J==\'11\'&&v<i.2J)v=i.2J;7(F i.28==\'11\'&&v>i.28)v=i.28}7(v<1)v=1;H v}E 4f(s){7(!32(s))s=[[s]];7(!32(s[0]))s=[s];1r(8 j=0,l=s.Q;j<l;j++){7(F s[j][0]==\'1i\')s[j][0]=$(s[j][0]);7(F s[j][1]!=\'1k\')s[j][1]=I;7(F s[j][2]!=\'1k\')s[j][2]=I;7(F s[j][3]!=\'11\')s[j][3]=0}H s}E 4M(k){7(k==\'2z\')H 39;7(k==\'1o\')H 37;7(k==\'45\')H 38;7(k==\'5C\')H 40;H-1}E 4v(n,v){7(n)34.1P=n+\'=\'+v+\'; 78=/\'}E 5H(n){n+=\'=\';8 b=34.1P.2I(\';\');1r(8 a=0,l=b.Q;a<l;a++){8 c=b[a];2l(c.5I(0)==\' \'){c=c.3V(1,c.Q)}7(c.2s(n)==0){H c.3V(n.Q,c.Q)}}H 0}E 3w(p){7(p&&F p==\'1i\'){8 i=(p.2s(\'79\')>-1)?I:K,r=(p.2s(\'2D\')>-1)?I:K}N{8 i=r=K}H[i,r]}E 4G(a){H(F a==\'11\')?a:2b}E 32(a){H F(a)==\'1e\'&&(a 7a 7b)}E 2j(){H 7c 7d().2j()}E 12(d,m){7(F d==\'1e\'){8 s=\' (\'+d.3z+\')\';d=d.12}N{8 s=\'\'}7(!d)H K;7(F m==\'1i\')m=\'1G\'+s+\': \'+m;N m=[\'1G\'+s+\':\',m];7(3W.4R&&3W.4R.5X)3W.4R.5X(m);H K}$.1M.5x=E(o){H 1a.1G(o)}})(7e);',62,449,'||||||opts|if|var|items||||||||||||||||||||||||||||||conf|function|typeof|cf_e|return|true|itms|false|scrl|visible|else|width|total|length|case|trigger|children|auto|css|bind|prev|first|next||number|debug|pagination|break|variable|visibleConf|anims|tt0|stopPropagation|this|padding|scroll|button|object|duration|pre|push|string|usePadding|boolean|slice|a_dur|height|left|data|container|for|marginRight|tmrs|switch|call|fx|triggerHandler|easing|align|undefined|play|sz_resetMargin|remove|wrp|post|carouFredSel|Math|cfs_origCssMargin|isScrolling|c_new|queu|fn|clbk|each|cookie|stopImmediatePropagation|onAfter|circular|sc_setScroll|Not|synchronise|isStopped|sc_startScroll|eq|l_old|w_siz|onBefore|crossfade|uncover|opacity|extend|direction|outerWidth|max|old|parseInt|null|c_old|l_cur|l_new|preventDefault|pauseOnHover|position|isNaN|getTime|isPaused|while|ms_getSizes|fade|cover|unbind|mousewheel|key|indexOf|css_o|adj|opts_orig|start|outerHeight|top|right|default|startTime|scrolling|resume|nv_enableNavi|last|updatePageStatus|slideTo|split|min|gn_getVisibleItemsNext|gi_getCurrentItems|minimum|pauseDuration|Carousel|hidden|pause|sc_clearTimers|ceil|cf_sortParams|events|queue|infinite|ms_getTotalSize|a_cur|a_old||gn_getItemIndex|is_array|removeClass|document|ani_o|to||||adjust|floor|of|go_getNaviObject|sc_stopScroll|timePassed|perc|dur2|prefix|appendTo|hide|apply|sc_callCallbacks|show|currentPosition|currentPage|jquery|before|sz_setSizes|nv_showNavi|event|addClass|bt_pauseOnHoverConfig|touchwipe|wN|selector|go_getObject|innerWidth|marginBottom|ms_getTrueLargestSize|parent|maxDimention|cf_getItemsAdjust|cf_getAlignPadding|keys|Number|absolute|none|100|onEnd|clone|orgW|cf_mapWrapperSizes|end|eval|mouseenter|mouseleave|substring|window|cur_l|sz|element||cfs_isCarousel|_cfs_init|configuration|defaults|up|ms_hasVariableSizes|ms_getTrueInnerSize|valid||center|bottom|page|anchorBuilder|delay|cf_getSynchArr|scrolled|float|marginTop|marginLeft|_cfs_unbind_events|stop|type|substr|conditions|gn_getVisibleItemsPrev|a_new|not|fx_cover|fx_uncover|orgDuration|cf_setCookie|xI|gn_getVisibleItemsNextTestCircular|gi_getOldItemsNext|gi_getNewItemsNext|slideToPage|linkAnchors|_cfs_bind_buttons|click|_cfs_unbind_buttons|mousewheelPrev|bt_mousesheelNumber|mousewheelNext|wipe|wrapper|new_w|old_w|cf_getKeyCode|ms_getLargestSize|toLowerCase|arr|sta|console|No|_cfs_currentPosition|_cfs_destroy|should|be|innerHeight|dx|cf_getPadding||500|pageAnchorBuilder|Item|backward|forward|_cfs_build|or||relative|cfs_origCss|_cfs_bind_events|finish|onPausePause|stopped|onPauseEnd|onPauseStart|is|enough|needed|_cfs_slide_|_cfs_configuration|Scrolling|gi_getOldItemsPrev|gi_getNewItemsPrev|directscroll|get|filter|shift|new_m|jumpToStart|after|append|caroufredsel|hash|index|selected|destroy|down|keyup|keyCode|configs|classname|cf_readCookie|charAt|random|itm|onCreate|namespace|span|animate|complete|disabled|cfs_tempCssMargin|s1|s2|l1|l2|join|log|found|The|option|moved|the|second|Infinity|Set|caroufredsel_cookie_|attr|id|2500|Available|widths|heights|automatically|fixed|Carousels|CSS|attribute|static|overflow|setTimeout|Page|resumed|currently|Callback|returned|_cfs_slide_prev|prependTo|concat|_cfs_slide_next|prevPage|nextPage|prepend|carousel|insertItem|removeItem|round|currentVisible|body|find|replaceWith|min_move_x|min_move_y|preventDefaultEvents|wipeUp|wipeDown|wipeLeft|wipeRight|timer|wrap|class|location|swing|cfs|div|caroufredsel_wrapper|href|continue|clearTimeout|fx_fade|hiding|navigation|paddingLeft|paddingRight|paddingTop|paddingBottom|px|em|even|odd|path|immediate|instanceof|Array|new|Date|jQuery'.split('|'),0,{}))
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

/*
* Slides, A Slideshow Plugin for jQuery
* Intructions: http://slidesjs.com
* By: Nathan Searles, http://nathansearles.com
* Version: 1.1.9
* Updated: September 5th, 2011
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
(function(a){a.fn.slides=function(b){return b=a.extend({},a.fn.slides.option,b),this.each(function(){function w(g,h,i){if(!p&&o){p=!0,b.animationStart(n+1);switch(g){case"next":l=n,k=n+1,k=e===k?0:k,r=f*2,g=-f*2,n=k;break;case"prev":l=n,k=n-1,k=k===-1?e-1:k,r=0,g=0,n=k;break;case"pagination":k=parseInt(i,10),l=a("."+b.paginationClass+" li."+b.currentClass+" a",c).attr("href").match("[^#/]+$"),k>l?(r=f*2,g=-f*2):(r=0,g=0),n=k}h==="fade"?b.crossfade?d.children(":eq("+k+")",c).css({zIndex:10}).fadeIn(b.fadeSpeed,b.fadeEasing,function(){b.autoHeight?d.animate({height:d.children(":eq("+k+")",c).outerHeight()},b.autoHeightSpeed,function(){d.children(":eq("+l+")",c).css({display:"none",zIndex:0}),d.children(":eq("+k+")",c).css({zIndex:0}),b.animationComplete(k+1),p=!1}):(d.children(":eq("+l+")",c).css({display:"none",zIndex:0}),d.children(":eq("+k+")",c).css({zIndex:0}),b.animationComplete(k+1),p=!1)}):d.children(":eq("+l+")",c).fadeOut(b.fadeSpeed,b.fadeEasing,function(){b.autoHeight?d.animate({height:d.children(":eq("+k+")",c).outerHeight()},b.autoHeightSpeed,function(){d.children(":eq("+k+")",c).fadeIn(b.fadeSpeed,b.fadeEasing)}):d.children(":eq("+k+")",c).fadeIn(b.fadeSpeed,b.fadeEasing,function(){a.browser.msie&&a(this).get(0).style.removeAttribute("filter")}),b.animationComplete(k+1),p=!1}):(d.children(":eq("+k+")").css({left:r,display:"block"}),b.autoHeight?d.animate({left:g,height:d.children(":eq("+k+")").outerHeight()},b.slideSpeed,b.slideEasing,function(){d.css({left:-f}),d.children(":eq("+k+")").css({left:f,zIndex:5}),d.children(":eq("+l+")").css({left:f,display:"none",zIndex:0}),b.animationComplete(k+1),p=!1}):d.animate({left:g},b.slideSpeed,b.slideEasing,function(){d.css({left:-f}),d.children(":eq("+k+")").css({left:f,zIndex:5}),d.children(":eq("+l+")").css({left:f,display:"none",zIndex:0}),b.animationComplete(k+1),p=!1})),b.pagination&&(a("."+b.paginationClass+" li."+b.currentClass,c).removeClass(b.currentClass),a("."+b.paginationClass+" li:eq("+k+")",c).addClass(b.currentClass))}}function x(){clearInterval(c.data("interval"))}function y(){b.pause?(clearTimeout(c.data("pause")),clearInterval(c.data("interval")),u=setTimeout(function(){clearTimeout(c.data("pause")),v=setInterval(function(){w("next",i)},b.play),c.data("interval",v)},b.pause),c.data("pause",u)):x()}a("."+b.container,a(this)).children().wrapAll('<div class="slides_control"/>');var c=a(this),d=a(".slides_control",c),e=d.children().size(),f=d.children().outerWidth(),g=d.children().outerHeight(),h=b.start-1,i=b.effect.indexOf(",")<0?b.effect:b.effect.replace(" ","").split(",")[0],j=b.effect.indexOf(",")<0?i:b.effect.replace(" ","").split(",")[1],k=0,l=0,m=0,n=0,o,p,q,r,s,t,u,v;if(e<2)return a("."+b.container,a(this)).fadeIn(b.fadeSpeed,b.fadeEasing,function(){o=!0,b.slidesLoaded()}),a("."+b.next+", ."+b.prev).fadeOut(0),!1;if(e<2)return;h<0&&(h=0),h>e&&(h=e-1),b.start&&(n=h),b.randomize&&d.randomize(),a("."+b.container,c).css({overflow:"hidden",position:"relative"}),d.children().css({position:"absolute",top:0,left:d.children().outerWidth(),zIndex:0,display:"none"}),d.css({position:"relative",width:f*3,height:g,left:-f}),a("."+b.container,c).css({display:"block"}),b.autoHeight&&(d.children().css({height:"auto"}),d.animate({height:d.children(":eq("+h+")").outerHeight()},b.autoHeightSpeed));if(b.preload&&d.find("img:eq("+h+")").length){a("."+b.container,c).css({background:"url("+b.preloadImage+") no-repeat 50% 50%"});var z=d.find("img:eq("+h+")").attr("src")+"?"+(new Date).getTime();a("img",c).parent().attr("class")!="slides_control"?t=d.children(":eq(0)")[0].tagName.toLowerCase():t=d.find("img:eq("+h+")"),d.find("img:eq("+h+")").attr("src",z).load(function(){d.find(t+":eq("+h+")").fadeIn(b.fadeSpeed,b.fadeEasing,function(){a(this).css({zIndex:5}),a("."+b.container,c).css({background:""}),o=!0,b.slidesLoaded()})})}else d.children(":eq("+h+")").fadeIn(b.fadeSpeed,b.fadeEasing,function(){o=!0,b.slidesLoaded()});b.bigTarget&&(d.children().css({cursor:"pointer"}),d.children().click(function(){return w("next",i),!1})),b.hoverPause&&b.play&&(d.bind("mouseover",function(){x()}),d.bind("mouseleave",function(){y()})),b.generateNextPrev&&(a("."+b.container,c).after('<a href="#" class="'+b.prev+'">Prev</a>'),a("."+b.prev,c).after('<a href="#" class="'+b.next+'">Next</a>')),a("."+b.next,c).click(function(a){a.preventDefault(),b.play&&y(),w("next",i)}),a("."+b.prev,c).click(function(a){a.preventDefault(),b.play&&y(),w("prev",i)}),b.generatePagination?(b.prependPagination?c.prepend("<ul class="+b.paginationClass+"></ul>"):c.append("<ul class="+b.paginationClass+"></ul>"),d.children().each(function(){a("."+b.paginationClass,c).append('<li><a href="#'+m+'">'+(m+1)+"</a></li>"),m++})):a("."+b.paginationClass+" li a",c).each(function(){a(this).attr("href","#"+m),m++}),a("."+b.paginationClass+" li:eq("+h+")",c).addClass(b.currentClass),a("."+b.paginationClass+" li a",c).click(function(){return b.play&&y(),q=a(this).attr("href").match("[^#/]+$"),n!=q&&w("pagination",j,q),!1}),a("a.link",c).click(function(){return b.play&&y(),q=a(this).attr("href").match("[^#/]+$")-1,n!=q&&w("pagination",j,q),!1}),b.play&&(v=setInterval(function(){w("next",i)},b.play),c.data("interval",v))})},a.fn.slides.option={preload:!1,preloadImage:"/img/loading.gif",container:"slides_container",generateNextPrev:!1,next:"next",prev:"prev",pagination:!0,generatePagination:!0,prependPagination:!1,paginationClass:"pagination",currentClass:"current",fadeSpeed:350,fadeEasing:"",slideSpeed:350,slideEasing:"",start:1,effect:"slide",crossfade:!1,randomize:!1,play:0,pause:0,hoverPause:!1,autoHeight:!1,autoHeightSpeed:350,bigTarget:!1,animationStart:function(){},animationComplete:function(){},slidesLoaded:function(){}},a.fn.randomize=function(b){function c(){return Math.round(Math.random())-.5}return a(this).each(function(){var d=a(this),e=d.children(),f=e.length;if(f>1){e.hide();var g=[];for(i=0;i<f;i++)g[g.length]=i;g=g.sort(c),a.each(g,function(a,c){var f=e.eq(c),g=f.clone(!0);g.show().appendTo(d),b!==undefined&&b(f,g),f.remove()})}})}})(jQuery)