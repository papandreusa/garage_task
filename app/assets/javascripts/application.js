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

function init(){
  handle_ajax('main_container');
  autohide_alert();
}

function handle_ajax(cont_id = 'main_container') {
  console.log('handle_ajax');
  $("[data-remote]")
  .on("ajax:success", function(event) {
    container_id = $(this).attr('target_container');
    if (container_id == undefined) container_id = cont_id;
    console.log(this.tagName + ': ' + $(this).attr('target_container'));
    [data, status, xhr] = event.detail;
    render_success_response( xhr, container_id);
  })
  .on("ajax:error", function(event){
    container_id = $(this).prop('target_container');
    if (container_id == undefined) container_id = cont_id;
    [data, status, xhr] = event.detail;
    $("#" + container_id).text( "<p>ERROR</p>" + xhr.responseText);
    render_status(xhr);
  })
}

function render_success_response( xhr, container_id) {
    data = JSON.parse(xhr.responseText);
    payload = data['payload'];
    content_type = data['content_type'];
    status = xhr.status;
    console.log(data);
  if (content_type == 'js') {
    render_js_data(payload, status);
  } else {
    render_html_data(payload, container_id);

    handle_ajax();
  }
  render_status(status);
  handle_ajax();
  autohide_alert();
}

function render_html_data(data, container_id) {
	$("#" + container_id).html(data);
}

function render_js_data(data, status) {
  // console.log(data);
  eval(data);
}

function render_status(status) {
	container = $('footer div.container');
  newDate = new Date();
	container.html('' + newDate.toLocaleTimeString() + ' ---  Status: ' + status );
}

function remote_request(cont_id, url){
  $.ajax({
    url: url,
    dataType: "json",
    success: function(data, status, xhr){
      render_success_response(xhr, cont_id);
    }
  });
}

function toggle_card(cont_id, url) {
  if ($( "#" + cont_id ).is( ":hidden" )) {
      $('#card_' + cont_id + '').html('loading ...');
      remote_request('card_' + cont_id, url);
  };
  // $('#' + cont_id).collapse('toggle');
}

function autohide_alert() {
	$("div.alert").fadeTo(5000, 500).slideUp(500, function(){
    $(this).remove();
	});
}
