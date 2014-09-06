module PRKit
  class ContextProject < Context

    def initialize(project_ids)
      @project_ids = project_ids
    end

    def run(query)
      responses = @project_ids.collect do |project_id|
        response = api_request(query.path(project_id), query.params)
        ApiResponse.new(response)
      end
      CompositeApiResponse.new(responses)
    end

  end
end
