$(window).load(function() {
  return $('a[data-target]').click(function(e) {
    var $this, new_icon, new_target, old_icon, url;
    e.preventDefault();
    $this = $(this);
    if ($this.data('target') === 'Add to') {
      url = $this.data('addurl');
      new_target = "Remove from";
      new_icon = "fa-times";
      old_icon = "fa-shopping-cart";
    } else {
      url = $this.data('removeurl');
      new_target = "Add to";
      new_icon = "fa-shopping-cart";
      old_icon = "fa-times";
    }
    return $.ajax({
      url: url,
      type: 'put',
      success: function(data) {
        $('.cart-count').html(data);
        $this.find('span').html(new_target);
        $this.find('i').addClass(new_icon).removeClass(old_icon);
        return $this.data('target', new_target);
      }
    });
  });
});

$(function(){
  $(".show-category-list").click(function(){
    $("#category-list").toggle(200);
  });
  $(".show-freshwater-list").click(function(){
    $("#freshwater-list").toggle(200);
  });
  $(".show-saltwater-list").click(function(){
    $("#saltwater-list").toggle(200);
  });
});

$(function(){
  $(".close-list").click(function(){
    $("#category-list").hide(200);
    $("#freshwater-list").hide(200);
    $("#saltwater-list").hide(200);
  });
});
