require 'spec_helper'
require './lib/query_project'

describe QueryProject do

  let(:project_id) { double }
  subject { QueryProject.new(project_id) }

  describe '#params' do

    context 'labels' do
      it 'adds a single label filter' do
        subject.label('apple')
        subject.params[:filter].should eq 'label:apple'
      end

      it 'adds filters for multiple single word labels' do
        subject.labels('apple', 'banana', 'pear')
        subject.params[:filter].should eq 'label:apple+label:banana+label:pear'
      end

      it 'add filters for single word and quotes multi word labels' do
        subject.labels('apple fruit', 'banana', 'pear drop')
        subject.params[:filter].should eq 'label:"apple fruit"+label:banana+label:"pear drop"'
      end

    end

    context 'states' do
      it 'adds a single state filter' do
        subject.status('unstarted')
        subject.params[:filter].should eq '(state:unstarted)'
      end 

      it 'adds filters for multiple states' do
        subject.status('unstarted', 'unfinished')
        subject.params[:filter].should eq '(state:unstarted+OR+state:unfinished)'
      end
    end

    context 'accepted' do
      context 'not specified' do
        it 'does not add accepted_after' do
          subject.params[:accepted_after].should be_nil
        end

        it 'does not add accepted_before' do
          subject.params[:accepted_before].should be_nil
        end
      end
      
      context 'specified' do
        let(:time) { Time.now }
        let(:time_in_ms) { double }
        before do
          allow(subject).to receive(:as_msec).with(time).and_return(time_in_ms)
        end



        it 'adds accepted_after' do
          subject.accepted(since: time)
          subject.params[:accepted_after].should eq time_in_ms
        end

        it 'adds accepted_before' do
          subject.accepted(before: time)
          subject.params[:accepted_before].should eq time_in_ms
        end
      end
    end

  end

end

