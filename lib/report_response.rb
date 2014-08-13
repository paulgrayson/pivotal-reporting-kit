class ReportResponse
  def initialize(raw_response)
    @raw_response = raw_response
    @json = nil
  end

  def ok?
    @raw_response.status == 200
  end

  def error?
    !ok?
  end

  def json
    @json ||= JSON.parse(@raw_response.body)
  end

  def item_count
    json.length
  end
end


