require 'socket'
require 'debug'
# require all .rb files in /lib
Dir.glob("./lib/*.rb").each {|file| require file }
# path = __dir__ + "/lib/*.rb"
# Dir[path].each {|file| require file }

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

      # binding.break
      if route
        params.merge! request.params
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

      if content.is_a?(Redirect)
        response = @constructor.redirect(content.location)
      elsif error
        response = error
      else
        content = nil if request.is_a?(HeadRequest)
        response = @constructor.build(headers: headers, content: content)
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

# require_relative "lib/utils.rb"