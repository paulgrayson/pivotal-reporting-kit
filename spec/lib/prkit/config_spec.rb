require 'spec_helper'
require './lib/prkit'

describe PRKit::Config do
  
  describe '#ensure_configured!' do
    it 'does not raise an error if api token configured' do
      expect do
        PRKit::Config.ensure_configured!
      end.to raise_exception
    end

    it 'raises an error if api token not configured' do
      expect do
        PRKit::Config.configure(api_token: "123434")
        PRKit::Config.ensure_configured!
      end.to_not raise_exception
    end
  end

end
