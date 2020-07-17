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

$(document).ready(function(){
  handle_ajax();
})

function handle_ajax() {
	console.log('handle_ajax');
	$("[data-remote]")
	.on("ajax:success", function(event) {
    [data, status, xhr] = event.detail;
		alert(JSON.stringify(event.currentTarget));
    render_response();
		render_response_status(data, xhr, event.currentTarget);
		handle_ajax();
  })
	.on("ajax:error", function(event){
    $("#main_container").html( "<p>ERROR</p>");
	})
}

// ------------------------------------------------------------------
function render_response_status(result, xhr, url) {
	container = $('footer div.container');
	container.html('Status: ' + xhr.status + ', Content_type: ' + xhr.getResponseHeader('content-type') + ', url: ' + url);
}

function render_response() {
	$("#main_container").html( xhr.responseText);
	autohide_alert();
}

function autohide_alert() {
	$("div.alert").fadeTo(5000, 500).slideUp(500, function(){
    $(this).remove();
	});
}
