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
    }).css('background-color', '#EDEBDE');


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
}); //end js  
