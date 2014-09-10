module PRKit
  class Stories < StoryFilter
    extend Forwardable
    def_delegators :@stories, :[], :each, :map, :collect, :filter, :select, :find, :index, :include, :count, :empty?, :length, :size

    def initialize(stories)
      @stories = stories
    end

    def all
      @stories
    end

    # returns stories that have all the labels (AND)
    def label(*labels)
      filtered_stories = @stories.select do |story|
        label_names = story['labels'].map {|label| label['name']}
        labels.all? {|label| label_names.include?(label) }
      end
      Stories.new(filtered_stories)
    end

    # returns stories in any of these states (OR)
    def status(*status)
      status_as_strings = status.map(&:to_s)
      filtered_stories = @stories.select do |story|
        status_as_strings.include?(story['current_state'])
      end
      Stories.new(filtered_stories)
    end

    def accepted(since_before=nil)
      if since_before.nil?
        status(:accepted)
      else
        comparator = since_before_comparator('accepted_at', since_before)
        filtered_stories = @stories.select {|story| story['accepted_at'] && comparator.call(story)}
        Stories.new(filtered_stories)
      end
    end

    def created(since_before)
      comparator = since_before_comparator('created_at', since_before)
      filtered_stories = @stories.select {|story| comparator.call(story)}
      Stories.new(filtered_stories)
    end

    def updated(since_before)
      comparator = since_before_comparator('updated_at', since_before)
      filtered_stories = @stories.select {|story| comparator.call(story)}
      Stories.new(filtered_stories)
    end

    private

    def since_before_comparator(field_key, since_before)
      if since_before[:before]
        lambda {|story| story[field_key] < since_before[:before]}
      else
        point_in_time = since_before[:after] || since_before[:since]
        lambda {|story| story[field_key] > point_in_time}
      end
    end
    
  end
end
