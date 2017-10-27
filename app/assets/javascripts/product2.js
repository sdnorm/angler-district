function readURL1(input) {
  if (input.files && input.files[0]) {

    var reader = new FileReader();

    reader.onload = function(e) {
      $('.image-upload-wrap1').hide();

      $('.file-upload-image1').attr('src', e.target.result);
      $('.file-upload-content1').show();

      $('.image-title1').html(input.files[0].name);
    };

    reader.readAsDataURL(input.files[0]);

  } else {
    removeUpload1();
  }
}

function removeUpload1() {
  $('.file-upload-input1').replaceWith($('.file-upload-input1').clone());
  $('.file-upload-content1').hide();
  $('.image-upload-wrap1').show();
}

$('.image-upload-wrap1').bind('dragover', function () {
  $('.image-upload-wrap1').addClass('image-dropping1');
});

$('.image-upload-wrap1').bind('dragleave', function () {
  $('.image-upload-wrap1').removeClass('image-dropping1');
});
