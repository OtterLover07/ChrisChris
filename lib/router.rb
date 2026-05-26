# A class handling and storing the routes for the server
class Router
    def initialize
        @routes = [] 
    end

    # stores a new GET route
    # @param path [String] the address of the route
    # @param block [Proc] the block corresponding to the route
    def get(path, &block)
        if block_given?
            add_route(:get, path, block)
        else
            raise ArgumentError "No block given"
        end
    end

    # stores a new POST route
    # @param path [String] the address of the route
    # @param block [Proc] the block corresponding to the route
    def post(path, &block)
        if block_given?
            add_route(:post, path, block)
        else
            raise ArgumentError "No block given"
        end
    end

    # Finds a stored route and returns the corresponding block
    # @param path [String] the address of the route
    # @param method [:get, :post] the method corresponding to the route (:get or :post)
    # @return [Proc, nil] the block corresponding to the route, or nil if none was found
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