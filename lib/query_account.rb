class QueryAccount

  def project_ids
    run.json.collect {|project| project['id']}
  end

  def projects
    run
  end

  def run
    ApiRequest.new(api_token).request(self)
  end

  def count
    run.item_count
  end

  def path
    "projects"
  end

  def params
    {}
  end

  private

  def api_token
    # TODO be better make this dependency explicit and fetch token from env outside this class
    ENV['PIVOTAL_API_TOKEN']
  end

end

