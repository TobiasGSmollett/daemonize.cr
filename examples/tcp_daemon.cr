require "../src/daemonize.cr"
require "socket"

# goes with tcp_client.cr

Process.daemonize

def process(client)
  client_addr = client.remote_address
  puts "#{client_addr} connected"

  while msg = client.read_line.chop
    Process.exit if msg == "exit"
    puts "#{client_addr} msg '#{msg}'\n"
    client.puts msg
  end
rescue IO::EOFError
  puts "#{client_addr} dissconnected"
ensure
  client.close
end

server = TCPServer.new "127.0.0.1", 9000
puts "listen on 127.0.0.1:9000"
loop { spawn process(server.accept) }
