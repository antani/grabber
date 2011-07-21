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
 pulsate();


 /*$('.help_img').hover(function () {
    $(this).find('strong').stop().fadeTo('normal', 1);
  }, function () {
    $(this).find('strong').stop().fadeTo('normal', 0);
  });
  */


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
$('#slideshow-reel').innerfade({animationtype: 'slide', speed: 750, timeout: 8000, type: 'random', containerheight: '1em' }); 
        //$('#portfolio').innerfade({ speed: 'slow', timeout: 4000, type: 'sequence', containerheight: '220px' }); 
        //$('.fade').innerfade({ speed: 'slow', timeout: 1000, type: 'sequence', containerheight: '1.5em' }); 


//Check if Geo location detection is supported
/*
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
*/	

 		



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
  	
//Add epllipsis
//ob = $('.div_top_books,.div_top_cameras,.div_top_mobiles,.div_top_movies').ThreeDots(); 
//ob.update({max_rows:1,whole_word:false,allow_dangle: true}); 

  	
  	
}); //end js  
