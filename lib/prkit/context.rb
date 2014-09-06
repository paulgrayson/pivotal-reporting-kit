module PRKit
  class Context

    def run(query)
      # TODO raise error that not implemented in derived class
    end

    private
    
    def api_request(path, params)
      api ||= ApiRequest.new
      api.request(path, params)
    end

  end
end
