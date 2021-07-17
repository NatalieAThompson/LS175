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
  # GET /?rolls=2&sides=6 HTTP/1.1
  next if !request_line || request_line =~ /favicon/
  # puts request_line

  http_method, path_and_params, http = request_line.split
  # path = request_line.scan()
  # /?rolls=2&sides=6
  path = path_and_params.scan(/(\/[a-z]*)/)[0]
  params = path_and_params.scan(/\?(.+)/)[0]
  params = format_params(params)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/plain\r\n\r\n"
  client.puts request_line


  params["rolls"].to_i.times do
    client.puts(rand(params["sides"].to_i) + 1)
  end
  client.close
end