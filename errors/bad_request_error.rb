class BadRequestError < StandardError
  def initialize(msg = "Bad request")
    super
  end
end
