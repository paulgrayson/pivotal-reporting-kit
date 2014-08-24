class CompositeApiResponse
  def initialize(api_responses)
    @api_responses = api_responses
  end

  def ok?
    !error?
  end

  def error?
    @api_responses.any? {|r| r.error?}
  end

  def data
    all = []
    @api_responses.each {|r| all.concat(r.data)}
    all
  end

  def count
    data.length
  end

end

