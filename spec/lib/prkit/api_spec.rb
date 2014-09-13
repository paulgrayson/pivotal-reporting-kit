require 'spec_helper'
require './lib/prkit'

describe PRKit::Api do
  describe '#request' do
    it 'checks that prkit has been configured' do
      connection = double(get: double)
      subject.stub(connection: connection)
      PRKit::Config.should_receive(:ensure_configured!).once
      subject.request(nil, nil)
    end
  end
end
