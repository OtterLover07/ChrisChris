class ResponseBuilder
    def initialize(version)
        @version = version.to_sym
    end

    def build(headers: {}, content:, status: nil)
        Response.new(@version, headers, content, status)
    end
end

class Response
    attr_accessor :headers, :content

    def initialize(version, headers, content, status)
        @version = version
        @headers = headers
        if content != nil
            @content = content.to_s
            @headers["content_length"] = @content.bytesize
        end

        if status
            @status = status
        else
            @status = "200 OK"
        end
        return self.clone
    end

    def to_s
        output = "#{@version.to_s} #{@status}\r\n"
        @headers.each { |header, value| output += "#{header}: #{value}\r\n" } if headers
        output += "\r\n#{@content}\r\n" if content
        p output
        return output
    end
end