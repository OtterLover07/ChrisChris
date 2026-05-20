class Router
    def initialize
        @routes = [] 
    end

    def get(path, &block)
        if block_given?
            add_route(:get, path, block)
        else
            raise ArgumentError "No block given"
        end
    end

    def post(path, &block)
        if block_given?
            add_route(:post, path, block)
        else
            raise ArgumentError "No block given"
        end
    end

    def match_route(path, method)
        @routes.each do |route|
            if route[:path] == path && route[:method] == method
                return [route, {}]
            elsif (params = route[:path].match(path)) && route[:method] == method
                return [route, params.named_captures(symbolize_names: true)]
            end
        end
        return nil
    end

    private

    def add_route(method, path, block)
        path = regexify_path(path) if path_dynamic?(path)

        @routes << {method: method, path: path, block: block}
    end

    def path_dynamic?(path)
        check = false
        path.split("/").each do |segment|
            check = true if segment.start_with?(":")
        end
        return check
    end

    def regexify_path(path)
        split_path = path.split("/")
        new_path = ''
        split_path.each do |segment|
            new_path << '/' if segment != ""
            if segment.start_with?(":")
                new_path << "(?<#{segment.delete_prefix(":")}>.+)"
            else
                new_path << segment
            end
        end
        Regexp.new(new_path)
    end
end

@r = Router.new