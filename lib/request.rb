class Request
    attr_reader :raw,:resource,:version,:headers,:params,:method,:cookies

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

    private

    # def display_request
    #     puts @method.to_s+" "+@resource+" "+@version
    #     @headers.each {|key, value| puts key+": "+value }
    #     if @params!={} then puts @params.to_s end
    # end

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

    def parse_params
        if @params == nil
            @params = {}
            return nil
        end
        step_1 = @params.split('&')
        step_2 = []
        step_1.each { |param| step_2 << param.split('=') }
        @params = step_2.to_h
    end
end

class GetRequest < Request
    # attr_reader :raw,:resource,:version,:headers,:params,:method
    
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

class PostRequest < Request
    # attr_reader :raw,:resource,:version,:headers,:params,:method

    def initialize(request, session)
        @method = :post
        @raw = request
        self.parse_request(request.chomp)

        if length = @headers["Content-Length"]
            @params = session.gets(length)
        else @params = nil end
        self.parse_params
    end
end
    
class HeadRequest < GetRequest
end