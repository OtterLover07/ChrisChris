# request.rb

# A class for easily handling incoming requests
class Request
    attr_reader :raw,:resource,:version,:headers,:params,:method,:cookies

    # Creates a new Request instance based on input data.
    # @param data [String] request data from the client.
    # @param session [TCPSocket] the server-client connection, used to get more data during POST requests.
    # @return [Object] the resulting request data condensed into a Request instance.
    # @raise [MethodError] if the incoming request is not a GET, POST or HEAD request.
    def self.build(data, session = nil)
        if data.start_with? "GET"
            return GetRequest.new(data)
        elsif data.start_with? "POST"
            return PostRequest.new(data, session)
        elsif data.start_with? "HEAD"
            return HeadRequest.new(data)
        else
            raise MethodError
        end
    end

    # (see #resource)
    def path_info
        self.resource
    end

    private

    # processes input data and distributes it among the proper attributes.
    # @param request [String] raw request data from the client
    # @private
    def parse_request(request)
        lines = request.split(/\r?\n/)
        
        dummy, @resource, @version = lines[0].split(" ")

        header_lines = []
        i = 1
        while (lines[i] != "") && (lines[i] != nil)
            header_lines << lines[i]
            i += 1
        end

        split_lines = []
        header_lines.each {|line| split_lines << line.split(": ")}
        @headers = split_lines.to_h
        if string = @headers["Cookie"]
            @cookies = Hash[string.split('; ').map { |pair| pair.split('=') }]
        end
    end

    # parses param data from the request and updates the params attribute
    def parse_params
        if @params == nil
            @params = {}
            return nil
        end
        step_1 = @params.split('&')
        step_2 = []
        step_1.each { |param| step_2 << param.split('=') }
        # binding.break
        step_2.each { |param| param << nil if param.length < 2}
        @params = step_2.to_h
    end
end

# A class containing the data of a GET request
class GetRequest < Request
    
    def initialize(request)
        @method = :get
        @raw = request
        self.parse_request(request.chomp)
        if @resource.include?("?")
            part_url = @resource.partition("?")
            @params = part_url[2]
            @resource = part_url[0] #removes params from @resource
        else @params = nil end
        self.parse_params
    end
end

# A class containing the data of a POST request
class PostRequest < Request

    def initialize(request, session)
        @method = :post
        @raw = request
        self.parse_request(request.chomp)

        if (length = @headers["Content-Length"]) != nil
            content = session.read(length.to_i)
            @params = content
        else @params = nil end
        self.parse_params
    end
end
    
# A class containing the data of a HEAD request
# @see #GetRequest
class HeadRequest < GetRequest
end