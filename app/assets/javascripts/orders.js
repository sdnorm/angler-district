$(function(){
  $("#toggle-button").click(function() {
    $("#change").toggle();
    $("#change2").toggle();
  });
});

$( ".card-hover" ).click(function() {
  $(".hide-card-form").toggle(600);
});
