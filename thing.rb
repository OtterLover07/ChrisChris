class String
    def split!(args = nil)
        self.map! {|i| self.split(args)}
    end
end

class Request
    def initialize(request)
        self.parse_request(request)
    end

    def parse_request (request)
        lines = request.split(/\r?\n/)
        if lines[0].start_with?("GET")
            @method = :GET
        elsif lines[0].start_with?("POST")
            @method = :POST
        else
            raise MethodError
        end
        lines[0] = lines[0].split(" ")
        @path = lines[0][1]
        @version = lines[0][2]

        header_lines = []
        i = 1
        while (lines[i] != "") && (lines[i] != nil)
            header_lines << lines[i]
            i += 1
        end

        split_lines = []
        header_lines.each {|line| split_lines << line.split(": ")}
        @headers = split_lines.to_h

        @params = lines[i+1]
    end

    def display_request
        puts @method.to_s+" "+@path+" "+@version
        @headers.each {|key, value| puts key+": "+value }
        puts @params
    end
end

requests = Dir.glob("example_requests/*")
requests.each do |filename|
    test_request = File.read(filename)
    request = Request.new(test_request)
    request.display_request
    puts ""
end


