
class Request

  attr_reader :path, :method, :headers

  attr_accessor :body

  def initialize(request_str)
    @request_str = request_str

    if @request_str.length < 1
      raise BadRequestError
    end

    if @request_str.lines[0].split.length < 3
      raise BadRequestError
    end

    method, @path, @version = @request_str.lines[0].split

    @method = method.to_sym

    @headers = {}
    @request_str.lines[1..-1].each do |line|
      if line == "\r\n"
        break
      end

      header, value = line.split
      header        = normalize(header)
      @headers[header] = value
    end

    @body = nil
    if @request_str.split("\r\n\r\n").length > 1
      @body = @request_str.split("\r\n\r\n")[1]
    end
  end

  def normalize(header)
    header.gsub(":", "").downcase.to_sym
  end

end
