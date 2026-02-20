class Router ## IDK if this works, men det var kvar från ett tag sedan så jag hade ju uppenbarligen nån idé då
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