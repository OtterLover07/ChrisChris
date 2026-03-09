require 'socket'
require_relative 'lib/request.rb'
require_relative 'lib/response.rb'
require_relative 'lib/router.rb'

# require_relative 'thing.rb' #dummy file for testing
require "debug"

class HTTPServer
  attr_reader :constructor, :router

  def initialize(port)
    @port = port
    @constructor = ResponseBuilder.new('HTTP/1.1')
    @router = Router.new
  end

  def start
    server = TCPServer.new(@port)
    puts "Listening on #{@port}"

    while session = server.accept
      data = ''
      while line = session.gets and line !~ /^\s*$/
        data += line
      end
      puts "RECEIVED REQUEST"
      puts '-' * 40
      puts data
      puts '-' * 40

      request = Request.build(data, session)

      route = @router.match_route request.resource
      if route
        response = route[:block].call
      # elsif [finns i public]
      #   response = @constructor.build([filen inläst])
      else
        response = @constructor.error(404)
      end


      # if @routes.include? request.resource
      #   response = @constructor.build(headers: headers, content: content)
      # else
        
      # end

      # session.print "HTTP/1.1 200\r\n"
      # session.print "Content-Type: text/html\r\n"
      # session.print "\r\n"
      # session.print content

      session.print response
      session.close
    end
  end
end

server = HTTPServer.new(4567)


server.router.get "/" do
  content = "<h1>Hello, World!</h1>" #if !request.is_a?(HeadRequest)
  headers = {"Content-Type": "text/html"}
  server.constructor.build(headers: headers, content: content)
end

server.router.get "/banan" do
  content = "<h1>Hello, World!</h1>" #if !request.is_a?(HeadRequest)
  headers = {"Content-Type": "text/html"}
  server.constructor.build(headers: headers, content: content)
end


server.start
