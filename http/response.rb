
class Response
  def initialize(client, request)
    @client = client
    @request = request
  end

  def encode(data)
    if data.is_a?(Hash) or data.is_a?(Array)
      return data.to_json
    end

    data
  end

  def send(data:, code:)
    encoded_data = encode(data)

    @response =
    "HTTP/1.1 #{code} OK\r\n" +
    "Content-Length: #{encoded_data.size}\r\n"

    if data.is_a?(Hash) or data.is_a?(Array)
      @response += "Content-Type: application/json\r\n"
    end

    @response += "\r\n"

    if @request.method != :"HEAD"
      @response += encoded_data
    end

    @client.write(@response)
  end
end
