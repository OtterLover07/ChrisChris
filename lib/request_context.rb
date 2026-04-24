require 'securerandom'

class RequestContext
    attr_reader :params,:request,:session_id
    def initialize(request, params, big_session=nil)
        @request = request
        @params = params
        @big_session = big_session
    end

    def redirect(location)
        Redirect.new(location)
    end
    def session
        # if !@settings[:sessions]
        #     return nil
        return nil if !request.cookies

        if !(@session_id = request.cookies["SessionIdentifier"])
            @session_id = SecureRandom.uuid
            @big_session[@session_id] = {}
        end
        return @big_session[@session_id]
    end
end
