class ResponseHandler

  def initialize(router)
    @router = router
  end

  def handle_request(request, response, next_middleware)
    @router.handle_request(request, response)
  end
end
