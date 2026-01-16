class Request
    attr_reader :raw,:method, :resource, :version, :headers, :params

    def initialize(request)
        @raw = request
        self.parse_request(request.chomp)
    end

    def display_request
        puts @method.to_s+" "+@resource+" "+@version
        @headers.each {|key, value| puts key+": "+value }
        if @params!={} then puts @params.to_s end
    end

    private

    def parse_request (request)
        lines = request.split(/\r?\n/)
        if lines[0].start_with?("GET")
            @method = :GET
        elsif lines[0].start_with?("POST")
            @method = :POST
        else
            raise MethodError
        end
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

        if @resource.include?("?")
            part_url = @resource.partition("?")
            @params = part_url[2]
        elsif @method == :POST
            @params = lines[i+1]
        else @params = nil end
        self.parse_params
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