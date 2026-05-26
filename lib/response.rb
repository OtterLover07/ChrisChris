# constructor class for building responses
class ResponseBuilder
    def initialize(version)
        @version = version.to_sym
    end

    # builds a response
    # @param headers [Hash] the desired headers
    # @param content [Object] the desired content, usually a string or plaintext
    # @param status [String, Integer] the desired status
    # @return [Response]
    def build(headers: {}, content:, status: nil)
        Response.new(@version, headers, content, status)
    end

    # builds a response containing only an error status
    # @param status [String, Integer] the desired status
    # @return [Response]
    def error(status)
        self.build(headers: nil, content: nil, status: status)
    end
end

# A class containing response data
class Response
    attr_accessor :headers, :content

    def initialize(version, headers, content, status)
        @version = version
        @headers = headers
        if content && content != ""
            @content = content.to_s
            @headers["Content-Length"] = @content.bytesize.to_s
        elsif !status
            status = 204
        end

        if status
            @status = self.status_case status
        else
            @status = "200 OK"
        end
        return self.clone
    end

    # converts response to a one-line string to be sent trough a terminal
    # @return [string]
    def to_s
        output = "#{@version.to_s} #{@status}\r\n"
        @headers.each { |header, value| output += "#{header}: #{value}\r\n" } if headers
        terminaloutput = output
        output += "\r\n#{@content}\r\n" if content
        terminaloutput += "\r\n#{@content}\r\n" if content && content.bytesize < 10000
        puts terminaloutput
        return output
    end

    private

    def status_case status
        case status.to_int

        # Informational Responses
        when 100
            "100 Continue"
        when 101
            "101 Switching Protocols"
        when 102
            "102 Processing"
        when 103
            "103 Early Hints"

        # Successful Responses
        when 200
            "200 OK"
        when 201
            "201 Created"
        when 202
            "202 Accepted"
        when 203
            "203 Non-Authoritative Information"
        when 204
            "204 No Content"
        when 205
            "205 Reset Content"
        when 206
            "206 Partial Content"
        when 207
            "207 Multi-Status"
        when 208
            "208 Already Reported"
        when 226
            "226 IM Used"
            
        # Redirection Messages
        when 300
            "300 Multiple Choices"
        when 301
            "301 Moved Permanently"
        when 302
            "302 Found"
        when 303
            "303 See Other"
        when 304
            "304 Not Modified"
        # when 305
            # "305 Use Proxy"
        # when 306
        #     "306 unused"
        when 307
            "307 Temporary Redirect"
        when 308
            "308 Permanent Redirect"
            
        # Client Error Responses
        when 400
            "400 Bad Request"
        when 401
            "401 Unauthorized"
        when 402
            "402 Payment Required"
        when 403
            "403 Forbidden"
        when 404
            "404 Not Found"
        when 405
            "405 Method Not Allowed"
        when 406
            "406 Not Acceptable"
        when 407
            "407 Proxy Authentication Required"
        when 408
            "408 Request Timeout"
        when 409
            "409 Conflict"
        when 410
            "410 Gone"
        when 411
            "411 Length Required"
        when 412
            "412 Precondition Failed"
        when 413
            "413 Content Too Large"
        when 414
            "414 URI Too Long"
        when 415
            "415 Unsupported Media Type"
        when 416
            "416 Range Not Satisfiable"
        when 417
            "417 Expectation Failed"
        when 418 #VIKTIG
            "418 I'm a teapot"
        when 421
            "421 Misdirected Request"
        when 422
            "422 Unprocessable Content"
        when 423
            "423 Locked"
        when 424
            "424 Failed Dependency"
        # when 425
        #     "425 Too Early"
        when 426
            "426 Upgrade Required"
        when 428
            "428 Precondition Required"
        when 429
            "429 Too Many Requests"
        when 431
            "431 Request Header Fields Too Large"
        when 451
            "451 Unavailable For Legal Reasons"

        # Server Error Responses
        when 500 #VIKTIG
            "500 Internal Server Error"
        when 501 #VIKTIG
            "501 Not Implemented"
        when 502 #VIKTIG
            "502 Bad Gateway"
        when 503
            "503 Service Unavailable"
        when 504
            "504 Gateway Timeout"
        when 505
            "505 HTTP Version Not Supported"
        when 506
            "506 Variant Also Negotiates"
        when 507
            "507 Insufficient Storage"
        when 508
            "508 Loop Detected"
        when 510
            "510 Not Extended"
        when 511
            "511 Network Authentication Required"
        else
            raise "Response not supported"
        end
    end
end