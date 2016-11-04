// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
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
//= require_tree .

$(function(){
    function debug(str){
        console.log(str);
    };
    ws = new WebSocket("ws://0.0.0.0:8080");
    ws.onmessage = function(message) {
        var comment = eval('(' + message.data +')');
        if (window.location.pathname == "/articles/" + comment["article_id"]) {
            var commentHtml = "<div class=\"comment\">" +
                "<strong>" + comment["name"] + "</strong>" +
                "<em> on " + comment["pretty_date"] + "</em>" +
                "<p>" + comment["content"] + "</p>";
            $('#comments').append(commentHtml);
        }
    };
    ws.onclose = function() {
        debug("WebSocket connection close");
    };
    ws.onopen = function() {
        debug("WebSocket connection open");
        ws.send("Hello Server");
    };
});