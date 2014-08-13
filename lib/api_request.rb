class ApiRequest

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

  def request(query)
    path = "/services/#{API_VERSION}/#{query.path}"
    response = connection.get(path) do |req|
      req.headers['X-TrackerToken'] = @api_token
      req.params = query.params
    end
    ApiResponse.new(response)
  end

end

