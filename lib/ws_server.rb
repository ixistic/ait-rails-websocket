require 'em-websocket'
require 'evma_httpserver'

class MyHttpServer < EventMachine::Connection
  include EventMachine::HttpServer
  def process_http_request
# the http request details are available via the following instance variables:
# @http_protocol
# @http_request_method
# @http_cookie
# @http_if_none_match
# @http_content_type
# @http_path_info
# @http_request_uri
# @http_query_string
# @http_post_content
# @http_headers
    @websocket_connections.each do |socket|
      socket.send(@http_post_content)
    end

    puts @http_post_content
    response = EventMachine::DelegatedHttpResponse.new(self)
    response.status = 200
    response.content_type 'text/html'
    response.content ='<center><h1>Hi there</h1></center>'
    response.send_response
  end
end

EM.run {
  websocket_connections = []
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do
      puts "WebSocket connection open"
    end
    ws.onclose do
      puts "Connection closed"
    end
    ws.onmessage do |msg|
      puts "Recieved message: #{msg}"
      websocket_connections << ws
    end
  end

  EM.start_server('0.0.0.0', 3001, MyHttpServer) { |conn|
    conn.instance_variable_set(:@websocket_connections , websocket_connections)
  }
}

