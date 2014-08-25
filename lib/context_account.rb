class ContextAccount < Context

  def run(query)
    response = api_request(query.path, query.params)
    ApiResponse.new(response)
  end

end

