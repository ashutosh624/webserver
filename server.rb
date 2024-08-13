require 'socket'
require_relative './router/router.rb'

require_relative './http/request.rb'
require_relative './http/response.rb'
require_relative './http/response_handler.rb'

class WebServer

  attr_reader :port, :hostname

  def initialize(hostname: 'localhost', port: 80)
    @hostname = hostname
    @port = port
    @listening = false
    @router = Router.new

    @middlewares = []
  end

  def get(path, callback)
    @router.register_route(:GET, path, callback)
  end

  def post(path, callback)
    @router.register_route(:POST, path, callback)
  end

  def use(middleware)
    @middlewares.push(middleware)
  end

  def next_middleware(request, response, index)
    if index < @middlewares.length
      @middlewares[index].handle_request(request, response, lambda {
        next_middleware(request, response, index + 1)
      })
    end
  end

  def listen(callback)
    if @listening
      raise "Server is already listening."
      return
    end

    server = TCPServer.new(@hostname, @port)

    if not @listening
      @listening = true
      callback.call
    end

    threads = []
    Thread.abort_on_exception = false

    begin
      loop {
        client = server.accept

        threads.push(Thread.new {
          
          request_str = ""
          last_request_str = ""
          count = 0
          length = 0

          loop {
            begin
              last_request_str = request_str
              request_str << client.readpartial(2048)
            rescue EOFError
            end
            
            # this is a workaround to fix postman requests.
            if request_str.length > 0 and request_str.length == last_request_str.length
              break
            end
          }
          request = Request.new(request_str)

          response = Response.new(client, request)

          @middlewares.push(ResponseHandler.new(@router))
          
          begin
            next_middleware(request, response, 0)
          rescue NotFoundError => e
            response.send(data: "Not found #{request.path}", code: 404)
          rescue BadRequestError => e
            response.send(data: "Invalid request", code: 400)
          rescue StandardError => e
            puts e.to_s
          end

          client.close
        })
      }
    rescue SignalException => e
      threads.each(:join)
      raise e
    rescue StandardError
      puts e.to_s
    end
  end

end

