class Report

  API_VERSION = 'v5'
  API_BASE_URI = 'https://www.pivotaltracker.com'

  def initialize(api_token)
    @api_token = api_token
  end

  def connection
    @connection ||= Faraday.new(url: API_BASE_URI) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def report(project_id, params)
    path = "/services/#{API_VERSION}/projects/#{project_id}/stories"
    response = connection.get(path) do |req|
      req.headers['X-TrackerToken'] = @api_token
      req.params = params
    end
    ReportResponse.new(response)
  end

end

