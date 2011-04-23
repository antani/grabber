// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(document).ready(function() {
    $('.tag_dummy:first').removeClass('tag_dummy').addClass("tags");
    $('body').noisy({
      'intensity' : 1,
      'size' : 200,
      'opacity' : 0.08,
      'fallback' : '',
      'monochrome' : false
    }).css('background-color', '#a2a096');

// if the browser supports the w3c geo api

if(readCookie("country")==null)
{
        
        if(navigator.geolocation){

	  // get the current position
	  navigator.geolocation.getCurrentPosition(

	  // if this was successful, get the latitude and longitude
	  function(position){
	    var lat = position.coords.latitude;
	    var lon = position.coords.longitude;
	    yqlgeo.get([lat,lon],function(o){

	       {  	  	
		  country = o.place.country.content;
		  createCookie("country",country,1);
	       }
	    })
	  },
	  // if there was an error
	  function(error){
		createCookie("country","USA",1);
	  });
	}
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


    var review_quote = "<div class='item_review_title_left'><img src='http://static.fkcdn.com/www/391/images/review_image.png' alt='*'></div>";
    $(review_quote).insertBefore('.gr_review_container.a');

    var editorial_review_books = $('#editorial_review').html();
    var start = editorial_review_books.search("About the Author");
    if(start>0) {
      var first_part = editorial_review_books.substring(0,start);
      var second_part = editorial_review_books.substring(start + ('About the Author').length, editorial_review_books.length-1);
      var final_parts = first_part + "<p class='about_author'>About the Author: <p>" + second_part;
      $('#editorial_review').html(final_parts);
    }
  var url = '/ #searching_from';
  $('#searching_from').load(url);  
  //$("#searching_from").refresh();


}); //end js  
