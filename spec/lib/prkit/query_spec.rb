require 'spec_helper'
require './boot'

describe PRKit::Query do

  before :each do
    PRKit::ApiRequest.any_instance.stub(request: double(data: []))
  end

  def create_raw_response(data)
    double(body: data.to_json, status: 200)
  end

  context 'features' do

    it 'queries all projects in the account' do
      # TODO re-write this in a nicer way
      proj_a = create_raw_response([id: 1])
      proj_b = create_raw_response([id: 2])
      proj_c = create_raw_response([id: 3])
      PRKit::ContextProject.any_instance.stub(:api_request).and_return(proj_a, proj_b, proj_c)
      account = create_raw_response([{id: 1}, {id: 2}, {id: 3}])
      PRKit::ContextAccount.any_instance.stub(:api_request).and_return(account)
      stories = PRKit::Query.all_projects.label(:flaky).status(:accepted).fetch
      stories.data.map {|s| s['id']}.should eq [1, 2, 3]
    end
  end

  describe 'project' do
    it 'returns a query' do
      project_id = double
      PRKit::Query.project(project_id).should be_a(PRKit::QueryProject)
    end
  end

end

