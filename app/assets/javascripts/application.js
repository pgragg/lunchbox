// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require nprogress
//= require nprogress-turbolinks 
//= require_tree .

NProgress.configure({
  showSpinner: false,
  ease: 'ease',
  speed: 1000,
  parent: '.loading_bar'
});


$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });


$(document).ready(function(){
  setTimeout(function(){
    $('.alert').fadeOut("slow", function() {
      $(this).remove();
    })
  }, 4500);
});