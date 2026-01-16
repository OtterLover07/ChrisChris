require_relative 'spec_helper'      # Laddar Minitest och mocks
require_relative '../lib/request'

class TestRequest < Minitest::Test
    def test_stores_raw_request_as_string
        request = Request.new(File.read('example_requests/get-examples.request.txt'))

        assert_instance_of Request, request
        assert_equal File.read('example_requests/get-examples.request.txt'), request.raw
    end

    def test_parses_method_path_and_version_correctly
        request = Request.new(File.read('example_requests/get-examples.request.txt'))
        post_request = Request.new(File.read('example_requests/post-login.request.txt'))

        assert_equal :GET, request.method
        assert_equal :POST, post_request.method
        assert_equal "/examples", request.resource
        assert_equal "HTTP/1.1", request.version
    end

    def test_parses_headers_correctly
        request = Request.new(File.read('example_requests/get-examples.request.txt'))

        assert_equal 4, request.headers.length
        assert_equal "example.com", request.headers["Host"]
        assert_equal "ExampleBrowser/1.0", request.headers["User-Agent"]
        assert_equal "gzip, deflate", request.headers["Accept-Encoding"]
        assert_equal "*/*", request.headers["Accept"]
    end
    
    def test_parses_post_params_correctly
        request = Request.new(File.read('example_requests/post-login.request.txt'))

        hash = {"username" => "grillkorv", "password" => "verys3cret!"}

        assert_equal hash, request.params
    end

    def test_parses_query_params_correctly
        request = Request.new(File.read('example_requests/get-fruits-with-filter.request.txt'))

        hash = {"type" => "bananas", "minrating" => "4"}

        assert_equal hash, request.params
        assert_equal "/fruits?type=bananas&minrating=4", request.resource
    end
end