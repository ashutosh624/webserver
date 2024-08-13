require_relative '../errors/bad_request_error.rb'
require_relative '../errors/not_found_error.rb'

class Router
  def initialize
    @handlers = {
      "GET": {},
      "POST": {},
      "PUT": {},
      "DELETE": {},
      "HEAD": {},
      "OPTIONS": {},
    }
  end

  def register_route(method, path, callback)
    if @handlers.has_key?(method)
      @handlers[method][path] = callback
    else
      raise HTTPMethodNotValid
    end
  end

  def handle_request(request, response)
    if @handlers.has_key?(request.method)
      if @handlers[request.method].has_key?(request.path)
        @handlers[request.method][request.path].call(request, response)
      else
        raise NotFoundError
      end
    else
      raise BadRequestError
    end
  end

end
