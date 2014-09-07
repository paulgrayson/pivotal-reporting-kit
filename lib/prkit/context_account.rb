module PRKit
  class ContextAccount < Context

    def run(query)
      api = Api.new
      response = api.request(query.path, query.params)
      ApiResponse.new(response)
    end

  end
end
