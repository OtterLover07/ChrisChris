require 'socket'
require 'zlib'
require_relative 'request.rb'
require_relative 'response.rb'
require_relative 'router.rb'

# require_relative 'thing.rb' #dummy file for testing
require "debug"

class HTTPServer
  attr_reader :constructor, :router

  def initialize(port, router)
    @port = port
    @constructor = ResponseBuilder.new('HTTP/1.1')
    @router = router
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

      route, params = @router.match_route request.resource, request.method
      params.merge! request.params
      # binding.break
      if route
        content = route[:block].call(params) 
        headers = {
          "Content-Type": "text/html"
        }
      elsif File.exist?("./public#{request.resource}") && !File.directory?("./public#{request.resource}")
        start = Time.now
        content = File.binread("./public#{request.resource}")
        filetype = determine_filetype request.resource
        headers = {
          "Content-Type": filetype
        }
      else
        error = @constructor.error(404)
      end


      content = nil if request.is_a?(HeadRequest)
      response = @constructor.build(headers: headers, content: content)

      if error
        response = error
      end

      session.print response
      session.close
    end
  end

  def determine_filetype filename
    if filename.end_with?(".jpg")
      "image/jpeg"
    elsif filename.end_with?(".jpeg")
      "image/jpeg"
    elsif filename.end_with?(".png")
      "image/png"
    elsif filename.end_with?(".apng")
      "image/apng"
    elsif filename.end_with?(".webp")
      "image/webp"
    elsif filename.end_with?(".svg")
      "image/svg+xml"
    elsif filename.end_with?(".html")
      "text/html"
    elsif filename.end_with?(".txt")
      "text/plain"
    elsif filename.end_with?(".csv")
      "text/csv"
    elsif filename.end_with?(".3mf")
      "model/3mf"
    elsif filename.end_with?(".mp4")
      "video/mp4"
    elsif filename.end_with?(".mp3")
      "audio/mp3"
    elsif filename.end_with?(".mpeg")
      "audio/mpeg"
    elsif filename.end_with?(".pdf")
      "application/pdf"
    elsif filename.end_with?(".zip")
      "application/zip"
    elsif filename.end_with?(".css")
      "text/css"
    elsif filename.end_with?(".js")
      "text/javascript"
    elsif filename.end_with?(".json")
      "application/json"
    elsif filename.end_with?(".gif")
      "image/gif"
    else
      "text/plain"
    end
  end

end

@r = Router.new

def server
  if @server
    @server
  else
    @server = HTTPServer.new(4567, @r)
  end
end

# server = HTTPServer.new(4567, @r)

def get(path, &block)
  @r.get(path, &block)
end

def post(path, &block)
  @r.post(path, &block)
end


# require_relative "app.rb"


# server.start
