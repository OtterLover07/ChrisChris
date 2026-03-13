require_relative "tcp_server.rb"

get "/" do
  return content = "<h1>Hello, World!</h1>" #if !request.is_a?(HeadRequest)
end

get "/banan" do
  return content = "<h1>Hello, World!</h1>" #if !request.is_a?(HeadRequest)
end


server.start
