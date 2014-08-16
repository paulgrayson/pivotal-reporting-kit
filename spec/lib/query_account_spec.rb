require 'spec_helper'
require './lib/query_account'

describe QueryAccount do

  describe '#run' do
    it 'calls the api' do
      api_request = double
      allow(subject).to receive(:api_request).and_return(api_request)
      expect do
        subject.run
        api_request.to receive(:request).with(subject)
      end
    end
  end

end

