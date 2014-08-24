require 'spec_helper'
require './lib/query_account'

describe QueryAccount do

  let(:context) { double }
  subject { QueryAccount.new(context) }

  describe '#projects' do
    it 'calls back the runner' do
      expect(context).to receive(:run).with(subject)
      subject.projects
    end
  end

end

