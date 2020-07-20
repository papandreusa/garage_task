// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//------------------------------------------------------------------
function init(){
  handle_ajax('main_container');
  autohide_alert();
}
//------------------------------------------------------------------
function handle_ajax(cont_id = 'main_container') {
  console.log('handle_ajax');
  $("[data-remote]")
  .on("ajax:success", function(event) {
    container_id = $(this).attr('target_container');
    if (container_id == undefined) container_id = cont_id;
    console.log(this.tagName + ': ' + $(this).attr('target_container'));
    [data, status, xhr] = event.detail;
    render_success_response(data, status, xhr, container_id);
  })
  .on("ajax:error", function(event){
    container_id = $(this).prop('target_container');
    if (container_id == undefined) container_id = cont_id;
    [data, status, xhr] = event.detail;
    $("#" + container_id).html( "<p>ERROR</p>");
    render_status(xhr);
  })
}
//------------------------------------------------------------------
function render_success_response(data, status, xhr, cont_id) {
  render_data(xhr, cont_id);
  render_status(xhr);
  handle_ajax();
  autohide_alert();
}
// ------------------------------------------------------------------
function render_data(xhr, container_id) {
	$("#" + container_id).html(xhr.responseText);
  // console.log(xhr.responseText);
}
// ------------------------------------------------------------------
function render_status(xhr) {
	container = $('footer div.container');
  newDate = new Date();
	container.html('' + newDate.toLocaleTimeString() + ': Status: ' + xhr.status );
}
//------------------------------------------------------------------
function autohide_alert() {
	$("div.alert").fadeTo(5000, 500).slideUp(500, function(){
    $(this).remove();
	});
}
//------------------------------------------------------------------
