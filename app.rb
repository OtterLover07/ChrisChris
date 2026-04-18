require 'slim'
require_relative "lib/tcp_server"

get "/" do
  "<h1>Hello, World!</h1>"
end

get "/hej" do
  redirect "/"
end

get "/banan" do
  "<h1>Hello, World!</h1>"
end

get "/users/:id" do |params|
  number = params[:id]
  number2 = params["id"]
  "<h1>#{number}, #{number2}</h1>"
end

get "/user/:id/post/:pid" do |params|
  params.to_s
end
server.start