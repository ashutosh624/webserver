
class LoggerMiddleware
  def handle_request(request, response, next_middleware)
    puts "#{request.method} #{request.path}"

    next_middleware.call
  end
end
