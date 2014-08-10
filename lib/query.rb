# all.label(:admin).event(:created).since(1.week.ago)
# project(12345).event(:accepted).between('2014-07-01', '2014-07-31')
# projects(12345, 78615).between('2014-07-01', '2014-07-31').owner('Paul Grayson')

class Query
  def initialize(project_scope, projects=nil)
    @project_scope = project_scope
    @include_projects = projects
  end

  def event(*events)
    @include_events = events
    self
  end
  alias :events :event

  def label(*labels)
    @include_labels = labels
    self
  end
  alias :labels :label

  def between(from, to)
    @from = from
    @to = to
    self
  end

  def since(from)
    @from = from
    @to = nil
    self
  end

  def run
    @report_response = Report.new.report(build_params)
  end

  def build_params
    {label: @include_labels}
  end

end

def all
  # TODO can we use https://www.pivotaltracker.com/help/api/rest/v5#me_resource to get project_ids
  Query.new(:all)
end

def project(*projects)
  Query.new(:specific, projects)
end
alias :projects :project

