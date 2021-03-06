module PRKit
  class QueryProject < StoryFilter

    def initialize(context)
      @context = context
      @states = []
      @labels = []
      @when_state_changed_filters = []
      @include_done = false
    end

    def accepted(since_before=nil)
      state_filter(:accepted, since_before)
    end

    def created(since_before=nil)
      state_filter(:created, since_before)
    end

    def updated(since_before=nil)
      state_filter(:updated, since_before)
    end

    def include_done
      @include_done = true
      self
    end

    # Valid values:
    # accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled
    def status(*status)
      @states = status
      self
    end

    def label(*labels)
      @labels = labels
      self
    end
    alias :labels :label

    def params
      params = {}
      params[:filter] = filter_param
      params
    end

    def path(project_id)
      "projects/#{project_id}/stories"
    end

    def fetch
      @context.run(self)
    end

    private

    def state_filter(state, since_before_range=nil)
      since_before, range = if since_before_range.is_a?(Array)
        [nil, since_before_range]
      else
        [since_before_range, nil]
      end
      if range
        @when_state_changed_filters << range_filter(state, range)
        self
      elsif since_before
        @when_state_changed_filters << since_before_filter(state, since_before)
        self
      else
        status(state)
      end
    end

    def range_filter(state, range)
      from = range[0]
      to = range[1]
      "#{state}:#{as_date(from)}..#{as_date(to)}"
    end

    def since_before_filter(state, since_before)
      after = since_before[:after] || since_before[:since]
      before = since_before[:before]
      if after
        "#{state}_after:#{as_date(after)}"
      elsif before
        "#{state}_before:#{as_date(before)}"
      end
    end

    def filter_param
      filters = @labels.map {|l| filter('label', l)}
      filters += @when_state_changed_filters if @when_state_changed_filters.any?
      filters += mutually_exclusive_filters('state', @states) if @states.any?
      filters << 'includedone:true' if @include_done
      filters.join(' ')
    end

    # TODO rename to or_mutually_exclusive_filters ?
    def mutually_exclusive_filters(filter_key, filter_values)
      filters = filter_values.map {|s| filter(filter_key, s)}
      if filters.length > 1
        ["(#{filters.join(' OR ')})"]
      elsif filters.length == 1
        ["#{filters[0]}"]
      else
        []
      end
    end

    def filter(key, label)
      "#{key}:#{escape_filter_value(label)}"
    end

    def escape_filter_value(value)
      if value[0] != '"' && value.to_s.include?(' ')
        "\"#{value}\""
      else
        value
      end
    end

    def as_date(datetime)
      datetime.strftime("%m/%d/%Y")
    end

  end

end
