# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).load ->
  $('a[data-target]').click (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('target') == 'Add to'
      url = $this.data('addurl')
      new_target = "Remove from"
      new_icon = "fa-times"
      old_icon = "fa-shopping-cart"
    else
      url = $this.data('removeurl')
      new_target = "Add to"
      new_icon = "fa-shopping-cart"
      old_icon = "fa-times"
    $.ajax url: url, type: 'put', success: (data) ->
      $('.cart-count').html(data)
      $this.find('span').html(new_target)
      $this.find('i').addClass(new_icon).removeClass(old_icon)
      $this.data('target', new_target)
