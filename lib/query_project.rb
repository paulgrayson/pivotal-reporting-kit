class QueryProject

  def initialize(project_id)
    @project_id = project_id
    @accepted_before, @accepted_after = nil
    @states = []
    @labels = []
  end

  # TODO maybe support not specifying since_before => state is just 'accepted'
  def accepted(since_before)
    @accepted_after = since_before[:since] || since_before[:after]
    @accepted_before = since_before[:before]
    self
  end

  # Valid values:
  # accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled
  def status(*status)
    @states = status
    self
  end

  def label(*labels)
    @labels = labels
    self
  end
  alias :labels :label

  def run
    ApiRequest.new(api_token).request(self)
  end

  def count
    run.item_count
  end

  def path
    "projects/#{@project_id}/stories"
  end

  def params
    params = {}
    params[:filter] = filter_param
    params[:accepted_after] = as_msec(@accepted_after) if @accepted_after
    params[:accepted_before] = as_msec(@accepted_before) if @accepted_before
    params
  end

  private

  def filter_param
    filters = @labels.map {|l| filter('label', l)}
    filters += mutually_exclusive_filters('state', @states) if @states.any?
    filters.join('+')
  end

  def mutually_exclusive_filters(filter_key, filter_values)
    filters = filter_values.map {|s| filter(filter_key, s)}
    ["(#{filters.join('+OR+')})"]
  end

  def filter(key, label)
    "#{key}:#{escape_filter_value(label)}"
  end

  def escape_filter_value(value)
    if value[0] != '"' && value.to_s.include?(' ')
      "\"#{value}\""
    else
      value
    end
  end

  def as_msec(datetime)
    datetime.to_i * 1000
  end

  def api_token
    # TODO be better make this dependency explicit and fetch token from env outside this class
    ENV['PIVOTAL_API_TOKEN']
  end

end


