## Please ignore this file for now, it is used mostly for testing purposes

class Router
    def initialize
        @gets = @posts = {}
    end

    def get(route, &block)
        if block_given?
            
        else
            return nil
        end
    end

    def post(route)
        if block_given?
            yield
        else
            return nil
        end
    end
    'add/:num1/:num2'
    /add\/(\w+)\/(\w+)/

end