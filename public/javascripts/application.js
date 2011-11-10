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
