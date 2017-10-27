function readURL3(input) {
  if (input.files && input.files[0]) {

    var reader = new FileReader();

    reader.onload = function(e) {
      $('.image-upload-wrap3').hide();

      $('.file-upload-image3').attr('src', e.target.result);
      $('.file-upload-content3').show();

      $('.image-title3').html(input.files[0].name);
    };

    reader.readAsDataURL(input.files[0]);

  } else {
    removeUpload3();
  }
}

function removeUpload3() {
  $('.file-upload-input3').replaceWith($('.file-upload-input3').clone());
  $('.file-upload-content3').hide();
  $('.image-upload-wrap3').show();
}

$('.image-upload-wrap3').bind('dragover', function () {
  $('.image-upload-wrap3').addClass('image-dropping3');
});

$('.image-upload-wrap3').bind('dragleave', function () {
  $('.image-upload-wrap3').removeClass('image-dropping3');
});
