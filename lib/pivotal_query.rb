class PivotalQuery

  def self.project(*projects)
    new.project(*projects)
  end

  def initialize
    @include_projects = nil
  end

  def project(*projects)
    @include_projects = projects
    self
  end
  alias :projects :project

  # TODO maybe support no since_before specified => state is just 'accepted'
  def accepted(since_before)
    @accepted_after = since_before[:since] || since_before[:after]
    @accepted_before = since_before[:before]
    self
  end

  # Valid values:
  # accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled
  def status(*status)
    @include_status = status
    self
  end

  def label(*labels)
    @include_labels = labels
    self
  end
  alias :labels :label

  def run
    # TODO support multiple projects
    project_id = @include_projects.first
    @report_response = Report.new(api_token).report(project_id, build_params)
  end

  def count
    run.item_count
  end

  def build_params
    params = {}
    params[:with_label] = value_list_as_param(@include_labels) if @include_labels && @include_labels.any?
    params[:with_state] = value_list_as_param(@include_status) if @include_status && @include_status.any?
    params[:accepted_after] = as_msec(@accepted_after) if @accepted_after
    params[:accepted_before] = as_msec(@accepted_before) if @accepted_before
    puts "TIME: #{Time.now.to_i}"
    params
  end

  private

  def value_list_as_param(array_of_values)
    # TODO quote to handle values with spaces e.g. labels
    array_of_values.join(',')
  end

  def as_msec(datetime)
    datetime.to_i * 1000
  end

  def api_token
    # TODO be better make this dependency explicit and fetch token from env outside this class
    ENV['PIVOTAL_API_TOKEN']
  end

end


