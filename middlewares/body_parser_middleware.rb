require 'json'

class BodyParserMiddleware

  def handle_request(request, response, next_middleware)
    
    if request.method == :POST
      if request.headers.has_key?(:"content-type")
        request.body = JSON.parse(request.body)
      end
    end

    next_middleware.call
  end

end
