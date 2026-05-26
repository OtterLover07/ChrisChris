# @see ResponseBuilder
class ResponseBuilder
  # Builds a redirection response
  # @param location [String] the route to redirect to
  def redirect(location)
    self.build(headers: {location: location}, content: nil, status: 303)
  end
end

# Redirect data
class Redirect
  attr_reader :location
  def initialize(location)
    @location = location
  end
end

# @see #Redirect.new
def redirect(location)
  Redirect.new(location)
end

# shorthand
# @see HTTPServer.new
def server
  if @server
    @server
  else
    @server = HTTPServer.new(4567, @r)
  end
end

# @see #Router.get
def get(path, &block)
  @r.get(path, &block)
end

# @see #Router.post
def post(path, &block)
  @r.post(path, &block)
end

# Renders a .slim file
# @param path [String] path to the .slim file
def slim(path)
  path = path.to_s
  template = Slim::Template.new("views/#{path}.slim")
  doc = template.render(self, wat: "dafuq")
  if File.exist?("./views/layout.slim")
    template2 = Slim::Template.new("views/layout.slim")
    doc = template2.render(self, wat: "dafuq") {doc}
    # doc = layout.gsub("==yield", doc)
  end
  doc
end
