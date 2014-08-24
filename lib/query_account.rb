class QueryAccount

  def initialize(context)
    @context = context
  end

  def project_ids
    projects.data.collect {|project| project['id']}
  end

  def projects
    @context.run(self)
  end

  def path
    "projects"
  end

  def params
    {}
  end

end

