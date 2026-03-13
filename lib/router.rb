class Router
    def initialize
        # @gets = [{:path => /^\/wat\/(<?wotid>\w+)\/wot/(\w+)$/, :block => block},{}] 
        @routes = [] 
    end

    def get(path, &block)
        # /wat/:watid/wot/:wotid
        if block_given?
            add_route(:get, path, block)
        else
            raise ArgumentError
        end
    end

    def post(route, &block)
        if block_given?
            add_route(:post, path, block)
        else
            raise ArgumentError
        end
    end
    # 'add/:num1/:num2'
    # /add\/(\w+)\/(\w+)/

    def match_route(path, method)
        @routes.each do |route|
            if route[:path] == path && route[:method] == method ######## FIXA SEN FÖR DYNAMISKA ROUTES###########
                return route
            end
        end
        return nil
    end

    private

    def add_route(method, path, block)
        @routes << {method: method, path: path, block: block}
    end
end