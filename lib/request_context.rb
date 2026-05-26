require 'securerandom'

# A class in the context of wich route blocks are run, in order to access the session hash
class RequestContext
    attr_reader :params,:request,:session_id
    def initialize(request, params, big_session=nil)
        @request = request
        @params = params
        @big_session = big_session
    end

    # stops the Proc, and the server to create a redirect response trough a rescue
    # @param location [String] the location where to redirect
    # @raise [RedirectError]
    def redirect(location)
        raise RedirectError, location
    end

    # gets the session hash corresponding to the client's identification number
    # @return [Hash]
    def session
        # if !@settings[:sessions]
        #     return nil
        return {} if !request.cookies

        if !(@session_id = request.cookies["SessionIdentifier"])
            @session_id = SecureRandom.uuid
            @big_session[@session_id] = {}
        elsif !@big_session[@session_id]
            @big_session[@session_id] = {}
        end
        # binding.break
        return @big_session[@session_id]
    end
end

# An error to be rescued by the server. This is done in order to stop running the route block.
class RedirectError < StandardError
end
