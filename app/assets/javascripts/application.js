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

$(function() {
  $("#users th a, #users .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#users_search input").keyup(function() {
    $.get($("#users_search").attr("action"), $("#users_search").serialize(), null, "script");
    return false;
  });
});


NProgress.configure({
  showSpinner: false,
  ease: 'ease',
  speed: 500,
  parent: 'body',
  template: '<div class = "page_modal"> <div class="bar" role="bar"><div class="peg"></div></div><div class="spinner" role="spinner"><div class="spinner-icon"></div></div></div>'
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