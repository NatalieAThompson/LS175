require "socket"

def format_params(params)
  return "/" if params.nil?
  # rolls=2&sides=6
  params = params[0].split("&")
  # [rolls=2, sides=6]
  params = params.map do |ele|
    ele.split("=")
  end.to_h
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  http_method, path_and_params, http = request_line.split

  path = path_and_params.scan(/(\/[a-z]*)/)[0]
  params = path_and_params.scan(/\?(.+)/)[0]
  params = format_params(params)

  # client.puts "HTTP/1.1 200 OK"
  # client.puts "Content-Type: text/plain\r\n\r\n"
  # client.puts request_line

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"
  client.close
end