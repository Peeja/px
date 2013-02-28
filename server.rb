require "socket"
require "openssl"
require "thread"

server = TCPServer.new(7247)
ssl_context = OpenSSL::SSL::SSLContext.new
ssl_context.cert = OpenSSL::X509::Certificate.new(File.open("users/bob/certificate.pem"))
ssl_context.key = OpenSSL::PKey::RSA.new(File.open("users/bob/key.pem"))
ssl_server = OpenSSL::SSL::SSLServer.new(server, ssl_context)

puts "Listening..."

loop do
  connection = ssl_server.accept
  Thread.new do
    begin
      while (line_in = connection.gets)
        line_in = line_in.chomp
        $stdout.puts "=> " + line_in
        line_out = "You said: " + line_in
        $stdout.puts "<= " + line_out
        connection.puts line_out
      end
      puts "Done"
      connection.close
    rescue
      $stderr.puts $!
    end
  end
end
