module PRKit
  class Query

    def self.all_projects
      context = ContextProject.new(self.account.project_ids)
      QueryProject.new(context)
    end

    def self.project(project_id)
      context = ContextProject.new([project_id])
      QueryProject.new(context)
    end

    def self.account
      context = ContextAccount.new
      QueryAccount.new(context)
    end

  end
end
