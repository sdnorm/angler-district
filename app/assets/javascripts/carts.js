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
    return $.ajax({
      type: "GET",
      dataType: "json",
      url: "cart/get-cart-total",
      success: function(data){
        $('.cart-total').html(data);
      }
    });
  });
});

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
        $.ajax({
          type: "GET",
          dataType: "json",
          url: "cart/get-cart-total",
          success: function(data2){
            $('.cart-total').html(data2);
          }
        });
        return $this.data('target', new_target);
      }
    });
  });
});
