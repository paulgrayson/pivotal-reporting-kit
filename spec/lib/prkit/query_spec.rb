require 'spec_helper'
require './boot'

describe PRKit::Query do

  before :each do
    PRKit::Api.any_instance.stub(request: double(data: []))
  end

  def create_raw_response(data)
    double(body: data.to_json, status: 200)
  end

  context 'features' do

    it 'queries all projects in the account' do
      responses = {
        'projects' => create_raw_response([{id: 1}, {id: 2}, {id: 3}]),
        'projects/1/stories' => create_raw_response([id: 1]),
        'projects/2/stories' => create_raw_response([id: 2]),
        'projects/3/stories' => create_raw_response([id: 3])
      }
      PRKit::Api.any_instance.stub(:request) {|inst, path, params| responses[path]}
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

