// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//=
//= require_tree .

$(function(){ $(document).foundation(); });

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
    columns: 3
  });
});

$(function(){
  $('.mobile-wrapper').masonry({
    columns: 1
  });
});
