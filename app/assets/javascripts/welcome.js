//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){
  setTimeout(function(){
    $('.alert').fadeOut("slow", function() {
      $(this).remove();
    })
  }, 2000);
});