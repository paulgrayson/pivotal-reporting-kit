module PRKit
  class ContextProject < Context

    def initialize(project_ids)
      @project_ids = project_ids
    end

    def run(query)
      responses = []
      api = Api.new
      api.transaction do
        @project_ids.collect do |project_id|
          responses << api.request(query.path(project_id), query.params)
        end
      end
      api_responses = responses.map {|r| ApiResponse.new(r)}
      CompositeApiResponse.new(api_responses)
    end

  end
end
