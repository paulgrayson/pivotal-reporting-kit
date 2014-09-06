require 'spec_helper'
require './lib/prkit'

describe PRKit::QueryAccount do

  let(:context) { double }
  subject { PRKit::QueryAccount.new(context) }

  describe '#projects' do
    it 'calls back the runner' do
      expect(context).to receive(:run).with(subject)
      subject.projects
    end
  end

end

