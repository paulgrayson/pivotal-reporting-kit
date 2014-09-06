require 'spec_helper'
require './lib/prkit'

describe PRKit::QueryProject do

  subject { PRKit::QueryProject.new(double) }

  describe '#params' do

    context 'labels' do
      it 'adds a single label filter' do
        subject.label('apple')
        subject.params[:filter].should eq 'label:apple'
      end

      it 'adds filters for multiple single word labels' do
        subject.labels('apple', 'banana', 'pear')
        subject.params[:filter].should eq 'label:apple label:banana label:pear'
      end

      it 'add filters for single word and quotes multi word labels' do
        subject.labels('apple fruit', 'banana', 'pear drop')
        subject.params[:filter].should eq 'label:"apple fruit" label:banana label:"pear drop"'
      end

    end

    context 'states' do
      it 'adds a single state filter' do
        subject.status('unstarted')
        subject.params[:filter].should eq 'state:unstarted'
      end 

      it 'adds filters for multiple states' do
        subject.status('unstarted', 'unfinished')
        subject.params[:filter].should eq '(state:unstarted OR state:unfinished)'
      end
    end

    shared_examples 'filter for when state changed' do |state|
      #
      # `state` the name of the state change we're filtering for e.g. accepted, created, updated
      #
      let(:state_after) { "#{state}_after".to_sym }
      let(:state_before) { "#{state}_before".to_sym }

      context 'not specified' do
        it 'does not add _after' do
          subject.params[state_after].should be_nil
        end

        it 'does not add _before' do
          subject.params[state_before].should be_nil
        end
      end
      
      context 'specified' do
        let(:time) { Time.now }
        let(:date) { double }
        before { allow(subject).to receive(:as_date).with(time).and_return(date) }

        it 'adds _after' do
          subject.send(state, since: time)
          subject.params[:filter].should eq "#{state_after}:#{date}"
        end

        it 'adds _before' do
          subject.send(state, before: time)
          subject.params[:filter].should eq "#{state_before}:#{date}"
        end
      end

      context 'no time specified' do
        it 'adds state filter' do
          subject.send(state)
          subject.params[:filter].should eq "state:#{state}"
        end
      end
    end

    context 'accepted' do
      it_behaves_like 'filter for when state changed', 'accepted'
    end

    context 'created' do
      it_behaves_like 'filter for when state changed', 'created'
    end

    context 'updated' do
      it_behaves_like 'filter for when state changed', 'updated'
    end

  end


end

