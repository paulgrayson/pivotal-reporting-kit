require 'spec_helper'
require './lib/prkit'

describe PRKit::Stories do

  def make_story(id, labels=[], state='unstarted', accepted_at=nil, created_at=nil, updated_at=nil)
    {
      'id' => id,
      'labels' => labels.map {|name| {'name' => name}},
      'current_state' => state,
      'accepted_at' => accepted_at,
      'updated_at' => updated_at,
      'created_at' => created_at
    }
  end

  def make_stories(opts)
    ids = opts.fetch(:ids)
    ids.map do |id|
      make_story(
        id,
        opts.fetch(:labels, []),
        opts.fetch(:current_state, 'unstarted'),
        opts.fetch(:accepted_at, nil),
        opts.fetch(:created_at, nil),
        opts.fetch(:updated_at, nil)
      )
    end
  end

  subject { PRKit::Stories.new(stories) }

  describe 'delegation to @stories' do
    let(:stories) { (1..5).map {|id| make_story(id)} }

    # just a few examples to check def_delegators present and working
    specify { subject[2]['id'].should eq 3 }
    specify { subject.length.should eq stories.length }
  end

  describe '#label' do
    let(:stories_with_no_label) { make_stories(ids: 1..5) }
    let(:stories_with_label1) { make_stories(ids: 6..8, labels: ['label1']) }
    let(:stories_with_multi_word_label) { make_stories(ids: 9..11, labels: ['multi word label']) }
    let(:stories_with_both_labels) { make_stories(ids: 12..13, labels: ['label1', 'multi word label']) }

    let(:stories) do
      stories_with_no_label + stories_with_label1 + stories_with_multi_word_label + stories_with_both_labels
    end

    it 'only returns stories with that one word label' do
      subject.label('label1').all.should eq (stories_with_label1 + stories_with_both_labels)
    end

    it 'only returns stories with that multi-word label' do
      subject.label('multi word label').all.should eq (stories_with_multi_word_label + stories_with_both_labels)
    end

    it 'only returns stories with both labels' do
      subject.label('label1', 'multi word label').all.should eq (stories_with_both_labels)
    end 
  end

  describe '#status' do
    let(:unstarted_stories) { make_stories(ids: (1..5), current_state: 'unstarted') }
    let(:accepted_stories) { make_stories(ids: (6..9), current_state: 'accepted') }
    let(:started_stories) { make_stories(ids: (10..11), current_state: 'started') }
    let(:stories) { unstarted_stories + accepted_stories + started_stories }

    it 'only returns stories with that status' do
      subject.status('unstarted').all.should eq (unstarted_stories)
    end

    it 'only returns stories with that status or the other status' do
      subject.status('unstarted', 'accepted').all.should eq (unstarted_stories + accepted_stories)
    end
  end

  let(:before_point_in_time) { Time.local(2014, 9, 9) }
  let(:point_in_time) { Time.local(2014, 9, 10) }
  let(:after_point_in_time) { Time.local(2014, 9, 11) }

  describe '#accepted' do
    let(:stories_accepted_before) { make_stories(ids: 1..2, current_state: 'accepted', accepted_at: before_point_in_time) }
    let(:stories_accepted_after) { make_stories(ids: 3..4, current_state: 'accepted', accepted_at: after_point_in_time) }
    let(:accepted_stories) { stories_accepted_after + stories_accepted_before }
    let(:started_stories) { make_stories(ids: 4..5, current_state: 'started') }
    let(:stories) { accepted_stories + started_stories }

    it 'only returns stories whose current state is accepted' do
      subject.accepted.all.should eq accepted_stories
    end

    it 'returns stories accepted before the specified time' do
      subject.accepted(before: point_in_time).all.should eq stories_accepted_before
    end

    it 'returns stories accepted after the specified time' do
      subject.accepted(after: point_in_time).all.should eq stories_accepted_after
    end

    it 'returns stories accepted since the specified time' do
      subject.accepted(since: point_in_time).all.should eq stories_accepted_after
    end
  end

  describe '#created' do
    let(:stories_created_before) { make_stories(ids: 1..2, created_at: before_point_in_time) }
    let(:stories_created_after) { make_stories(ids: 1..2, created_at: after_point_in_time) }
    let(:stories) { stories_created_before + stories_created_after }

    it 'only returns stories created before the specified time' do
      subject.created(before: point_in_time).all.should eq stories_created_before
    end

    it 'only returns stories created after the specified time' do
      subject.created(after: point_in_time).all.should eq stories_created_after
    end

    it 'only returns stories created since the specified time' do
      subject.created(since: point_in_time).all.should eq stories_created_after
    end
  end

  describe '#updated' do
    let(:stories_updated_before) { make_stories(ids: 1..2, updated_at: before_point_in_time) }
    let(:stories_updated_after) { make_stories(ids: 1..2, updated_at: after_point_in_time) }
    let(:stories) { stories_updated_before + stories_updated_after }

    it 'only returns stories updated before the specified time' do
      subject.updated(before: point_in_time).all.should eq stories_updated_before
    end

    it 'only returns stories updated after the specified time' do
      subject.updated(after: point_in_time).all.should eq stories_updated_after
    end

    it 'only returns stories updated since the specified time' do
      subject.updated(since: point_in_time).all.should eq stories_updated_after
    end
  end

end
