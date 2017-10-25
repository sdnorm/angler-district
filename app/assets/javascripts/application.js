// //= require masonry.pkgd
//= require jquery
//= require jquery_ujs
//= require foundation
//=
//= require_tree .

$(function(){ $(document).foundation(); });

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
