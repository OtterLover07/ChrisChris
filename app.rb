require 'slim'
require_relative "lib/tcp_server"

enable :sessions

get "/" do
  "<h1>Hello, World!</h1>"
end

get "/hej" do
  redirect "/"
end

get "/banan" do
  "<h1>Hello, World!</h1>"
end

get "/users/:id" do
  thing = params[:id]
  thing2 = params["id"]
  "<h1>#{thing}, #{thing2}</h1>"
end

get "/user/:id/post/:pid" do
  params.to_s
end

get "/save/:thing" do
  thing = params[:thing]
  session[:something] = thing
  "<h1>Saved '#{thing}' to Session</h1>"
end

get "/saved" do
  thing = session[:something]
  p session
  "<h1>#{thing}</h1>"
end

server.start