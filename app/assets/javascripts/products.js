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
    $("#category-list").slideToggle(200);
    $("#freshwater-list").hide(200);
    $("#saltwater-list").hide(200);
  });
  $(".show-freshwater-list").click(function(){
    $("#freshwater-list").slideToggle(200);
    $("#category-list").slideUp(200);
    $("#saltwater-list").slideUp(200);
  });
  $(".show-saltwater-list").click(function(){
    $("#saltwater-list").slideToggle(200);
    $("#category-list").slideUp(200);
    $("#freshwater-list").slideUp(200);
  });
});

$(function(){
  $(".close-list").click(function(){
    $("#category-list").slideUp(200);
    $("#freshwater-list").slideUp(200);
    $("#saltwater-list").slideUp(200);
  });
});

function readURL(input) {
  if (input.files && input.files[0]) {

    var reader = new FileReader();

    reader.onload = function(e) {
      $('.image-upload-wrap').hide();

      $('.file-upload-image').attr('src', e.target.result);
      $('.file-upload-content').show();

      $('.image-title').html(input.files[0].name);
    };

    reader.readAsDataURL(input.files[0]);

  } else {
    removeUpload();
  }
}

function removeUpload() {
  $('.file-upload-input').replaceWith($('.file-upload-input').clone());
  $('.file-upload-content').hide();
  $('.image-upload-wrap').show();
}

$('.image-upload-wrap').bind('dragover', function () {
  $('.image-upload-wrap').addClass('image-dropping');
});

$('.image-upload-wrap').bind('dragleave', function () {
  $('.image-upload-wrap').removeClass('image-dropping');
});
