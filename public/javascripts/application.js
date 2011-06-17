// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//'#E8E8E2'

$(document).ready(function() {

//Add validations
var validator = $('#searchfrm').validate(
{
  rules:{q: 'required' } ,
  messages:{q: 'Hold on cowboy, give us something to search.'}
}
);

$('.tag_dummy:first').removeClass('tag_dummy').addClass("tags");
$('body').noisy({
      'intensity' : 1,
      'size' : 200,
      'opacity' : 0.08,
      'fallback' : '',
      'monochrome' : false
}).css('background-color', '#E8E8E2');

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

$('#searchbooks').click(function() {
            $('#search_type').val('books');
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchmobiles').removeClass('active');
            $('#searchcamera').removeClass('active');
          });
$('#searchmovies').click(function() {
            $('#search_type').val('movies');
            $(this).addClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchmobiles').removeClass('active');
            $('#searchcamera').removeClass('active');
          });
$('#searchmobiles').click(function() {
            $('#search_type').val('mobiles');
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchcamera').removeClass('active');
          });
$('#searchcamera').click(function() {
            $('#search_type').val('cameras');
            $(this).addClass('active');
            $('#searchmovies').removeClass('active');
            $('#searchbooks').removeClass('active');
            $('#searchmobiles').removeClass('active');
          });


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
//Check if Geo location detection is supported
if(readCookie("country") == null)
{
	if (geo_position_js.init()) {
	
                                geo_position_js.getCurrentPosition(
				function geo_success(p)
				{
					 yqlgeo.get([p.coords.latitude,p.coords.longitude],function(o){

					       {  	  	
						  country = o.place.country.content;
						  createCookie("country",country,1);
                                                  sendMessage("Your location is set to : " + readCookie("country"));
				       }
					 });
					
		  


				},

				function geo_error(p)
				{
					createCookie("country","USA",1);
	                                sendMessage("Your location is set to : " + readCookie("country"));
				

				});
	}
}
	
/*-----------------Feedback Slideshow----------------------------------*/
function changeSlide( newSlide ) {
        // cancel any timeout
        clearTimeout( slideTimeout );
        
        // change the currSlide value
        currSlide = newSlide;
        
        // make sure the currSlide value is not too low or high
        if ( currSlide > maxSlide ) currSlide = 0;
        else if ( currSlide < 0 ) currSlide = maxSlide;
        
        // animate the slide reel
        $slideReel.animate({
            left : currSlide * -900
        }, 400, 'swing', function() {
            // hide / show the arrows depending on which frame it's on
            if ( currSlide == 0 ) $slideLeftNav.hide();
            else $slideLeftNav.show();
            
            if ( currSlide == maxSlide ) $slideRightNav.hide();
            else $slideRightNav.show();
            
            // set new timeout if active
            if ( activeSlideshow ) slideTimeout = setTimeout(nextSlide, 5200);
        });
        
        // animate the navigation indicator
        $activeNavItem.animate({
            left : currSlide * 150
        }, 400, 'swing');
    }
    
    function nextSlide() {
        changeSlide( currSlide + 1 );
    }
    
    // define some variables / DOM references
    var activeSlideshow = true,
    currSlide = 0,
    slideTimeout,
    $slideshow = $('#slideshow'),
    $slideReel = $slideshow.find('#slideshow-reel'),
    maxSlide = $slideReel.children().length - 1,
    $slideLeftNav = $slideshow.find('#slideshow-left'),
    $slideRightNav = $slideshow.find('#slideshow-right'),
    $activeNavItem = $slideshow.find('#active-nav-item');
    
    // set navigation click events
    
    // left arrow
    $slideLeftNav.click(function(ev) {
        ev.preventDefault();
        
        activeSlideshow = false;
        
        changeSlide( currSlide - 1 );
    });
    
    // right arrow
    $slideRightNav.click(function(ev) {
        ev.preventDefault();
        
        activeSlideshow = false;
        
        changeSlide( currSlide + 1 );
    });
    
    // main navigation
    $slideshow.find('#slideshow-nav a.nav-item').click(function(ev) {
        ev.preventDefault();
        
        activeSlideshow = false;
        
        changeSlide( $(this).index() );
    });
    
    // start the animation
    slideTimeout = setTimeout(nextSlide, 5200);




/*    var review_quote = "<div class='item_review_title_left'><img src='http://static.fkcdn.com/www/391/images/review_image.png' alt='*'></div>";
    $(review_quote).insertBefore('.gr_review_container.a');
    var editorial_review_books = $('#editorial_review').html();
    var start = editorial_review_books.search("About the Author");
    if(start>0) 
    {
	      var first_part = editorial_review_books.substring(0,start);
	      var second_part = editorial_review_books.substring(start + ('About the Author').length, editorial_review_books.length-1);
	      var final_parts = first_part + "<p class='about_author'>About the Author: <p>" + second_part;
	      $('#editorial_review').html(final_parts);
    }
*/
  	
}); //end js  
