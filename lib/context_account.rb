class ContextAccount < Context

  def run(query)
    response = ApiRequest.new(api_token).request(query.path, query.params)
    ApiResponse.new(response)
  end

end

