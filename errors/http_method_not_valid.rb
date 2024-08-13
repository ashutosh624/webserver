class HTTPMethodNotValid < StandardError
  def initialize(msg = "HTTP method is not valid")
    super
  end
end
