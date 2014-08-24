require 'spec_helper'
require './boot'

describe Query do

  before :each do
    ApiRequest.any_instance.stub(request: double(data: []))
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
      account = create_raw_response([{id: 1}, {id: 2}, {id: 3}])
      ApiRequest.stub(:new).and_return(
        double(request: account),
        double(request: proj_a),
        double(request: proj_b),
        double(request: proj_c)
      )
      stories = Query.all_projects.label(:flaky).status(:accepted).fetch
      stories.data.map {|s| s['id']}.should eq [1, 2, 3]
    end
  end

  describe 'project' do
    it 'returns a query' do
      project_id = double
      Query.project(project_id).should be_a(QueryProject)
    end
  end

end

