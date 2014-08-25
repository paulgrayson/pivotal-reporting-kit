class Context

  def run(query)
    # TODO raise error that not implemented in derived class
  end

  private
  
  def api_request(path, params)
    api ||= ApiRequest.new(api_token)
    api.request(path, params)
  end

  def api_token
    # TODO be better make this dependency explicit and fetch token from env outside this class
    ENV['PIVOTAL_API_TOKEN']
  end

end

