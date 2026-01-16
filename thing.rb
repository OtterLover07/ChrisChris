require_relative 'lib/request'

# requests = Dir.glob("example_requests/*")
Dir.each_child('example_requests') do |filename|
    test_request = File.read("example_requests/#{filename}")
    request = Request.new(test_request)
    request.display_request
    puts ""
end