function readURL4(input) {
  if (input.files && input.files[0]) {

    var reader = new FileReader();

    reader.onload = function(e) {
      $('.image-upload-wrap4').hide();

      $('.file-upload-image4').attr('src', e.target.result);
      $('.file-upload-content4').show();

      $('.image-title4').html(input.files[0].name);
    };

    reader.readAsDataURL(input.files[0]);

  } else {
    removeUpload4();
  }
}

function removeUpload4() {
  $('.file-upload-input4').replaceWith($('.file-upload-input4').clone());
  $('.file-upload-content4').hide();
  $('.image-upload-wrap4').show();
}

$('.image-upload-wrap4').bind('dragover', function () {
  $('.image-upload-wrap4').addClass('image-dropping4');
});

$('.image-upload-wrap4').bind('dragleave', function () {
  $('.image-upload-wrap4').removeClass('image-dropping4');
});
