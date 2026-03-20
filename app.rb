require_relative "lib/tcp_server.rb"

get "/" do
  content = "<h1>Hello, World!</h1>" #if !request.is_a?(HeadRequest)
end

get "/banan" do
  content = "<h1>Hello, World!</h1>" #if !request.is_a?(HeadRequest)
end

get "/users/:id" do |params|
  number = params[:id]
  number2 = params["id"]
  content = "<h1>#{number}, #{number2}</h1>" #if !request.is_a?(HeadRequest)
end


server.start
