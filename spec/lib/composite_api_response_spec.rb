require 'spec_helper'
require './lib/composite_api_response'

describe CompositeApiResponse do

  describe '#error?' do
    let(:ok_response)     { double(error?: false) }
    let(:error_response)  { double(error?: true) }

    it 'is ok if all responses are ok' do
      composite = CompositeApiResponse.new([ok_response, ok_response])
      composite.error?.should eq false
    end

    it 'is an error if any responses are error' do
      composite = CompositeApiResponse.new([ok_response, error_response, ok_response])
      composite.error?.should eq true
    end
  end

  describe '#data' do
    it 'concatenates data from each response' do
      items = [double, double, double, double]
      response1 = double(data: items[0..0])
      response2 = double(data: items[1..2])
      response3 = double(data: items[3..3])
      composite = CompositeApiResponse.new([response1, response2, response3])
      composite.data.should eq items
    end
  end

end

