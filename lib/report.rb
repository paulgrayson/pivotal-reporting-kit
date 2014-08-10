class Report

  def connection
    @connection ||= Faraday.new(url: 'https://www.pivotaltracker.com') do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def report(params)
    response = connection.get('/services/v5/projects/687551/activity') do |req|
      req.headers['X-TrackerToken'] = ENV['PIVOTAL_API_TOKEN']
      req.params = params
    end
    ReportResponse.new(response)
  end

end

