// //= require masonry.pkgd
//= require jquery
//= require jquery_ujs
//= require foundation
//=
//= require_tree .

// $(document).foundation();

// $(function(){ $(document).foundation(); });

$(document).on('turbolinks:load', () ->
  $(document).foundation()
)

function openNav() {
  document.getElementById("mySidenav").style.width = "250px";
  // document.getElementById("main").style.marginLeft = "250px";
  document.body.style.backgroundColor = "#ecf0f1";
  document.getElementById("ham-menu").style.display = "none";
  document.getElementById("close-menu").style.display = "inline";
}

function closeNav() {
  document.getElementById("mySidenav").style.width = "0";
  // document.getElementById("main").style.marginLeft= "0";
  document.body.style.backgroundColor = "white";
  document.getElementById("ham-menu").style.display = "inline";
  document.getElementById("close-menu").style.display = "none";
}

$(function($){
  $.fn.masonry = function(params){
    var defaults = {
      columns: 3
    };

    var options = $.extend(defaults, params),
        container = this,
        items = container.find('.item'),
        colCount = 0,
        columns = $(Array(options.columns + 1).join('<div></div>')).addClass('masonryColumn').appendTo(container);
    for(var c = 0; c < items.length; c++){
      items.eq(c).appendTo(columns.eq(colCount));
      colCount = (colCount + 1 > (options.columns - 1)) ? 0 : colCount + 1;
    }
  }
}(jQuery));

$(function(){
  $('.wrapper').masonry({
    columns: 4
  });
});
