class NotFoundError < StandardError
  def initialize(msg = "NOT Found")
    super
  end
end
