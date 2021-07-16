require "socket"

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  # puts request_line

  http_method = "GET"
  # path = request_line.scan()
  path = "/"
  params = {
    "rolls" => "2",
    "sides" => "6"
  }

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/plain\r\n\r\n"
  client.puts request_line


  params["rolls"].to_i.times do
    client.puts(rand(params["sides"].to_i) + 1)
  end
  client.close
end