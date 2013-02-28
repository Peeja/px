#!/usr/bin/ruby

require 'socket'
require 'openssl'

socket = TCPSocket.new('localhost', 7247)

ssl_context = OpenSSL::SSL::SSLContext.new
ssl_context.cert = OpenSSL::X509::Certificate.new(File.open("users/alice/certificate.pem"))
ssl_context.key = OpenSSL::PKey::RSA.new(File.open("users/alice/key.pem"))
ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
ssl_socket.sync_close = true
ssl_socket.connect

ssl_socket.puts("Hi, there!")
ssl_socket.close
