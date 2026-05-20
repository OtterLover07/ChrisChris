class ResponseBuilder
  def redirect(location)
    self.build(headers: {location: location}, content: nil, status: 303)
  end
end

class Redirect
  attr_reader :location
  def initialize(location)
    @location = location
  end
end

def redirect(location)
  Redirect.new(location)
end

def server
  if @server
    @server
  else
    @server = HTTPServer.new(4567, @r)
  end
end

def get(path, &block)
  @r.get(path, &block)
end

def post(path, &block)
  @r.post(path, &block)
end

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
