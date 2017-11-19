//= require jquery
//= require jquery_ujs
//= require foundation
//=require side_menu
//= require_tree .

// $(function(){ $(document).foundation(); });

$(document).foundation();


function openMobileSignedNav() {
  document.getElementById("signedMobileNav").style.width = "300px";
}

function closeMobileSignedNav() {
  document.getElementById("signedMobileNav").style.width = "0";
}
