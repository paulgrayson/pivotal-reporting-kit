module PRKit
  class QueryProject

    def initialize(context)
      @context = context
      @accepted_filters = {}
      @created_filters = {}
      @updated_filters = {}
      @states = []
      @labels = []
      @include_done = false
    end

    def accepted(since_before=nil)
      if since_before
        when_state_changed_filter(@accepted_filters, since_before)
      else
        status(:accepted)
      end
    end

    def created(since_before=nil)
      if since_before
        when_state_changed_filter(@created_filters, since_before)
      else
        status(:created)
      end
    end

    def updated(since_before=nil)
      if since_before
        when_state_changed_filter(@updated_filters, since_before)
      else
        status(:updated)
      end
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
      params[:accepted_after] = as_msec(@accepted_filters[:after]) if @accepted_filters[:after]
      params[:accepted_before] = as_msec(@accepted_filters[:before]) if @accepted_filters[:before]
      params[:created_after] = as_msec(@created_filters[:after]) if @created_filters[:after]
      params[:created_before] = as_msec(@created_filters[:before]) if @created_filters[:before]
      params[:updated_after] = as_msec(@updated_filters[:after]) if @updated_filters[:after]
      params[:updated_before] = as_msec(@updated_filters[:before]) if @updated_filters[:before]
      params
    end

    def path(project_id)
      "projects/#{project_id}/stories"
    end

    def fetch
      @context.run(self)
    end

    private

    def when_state_changed_filter(state_filters, since_before)
      state_filters[:after] = since_before[:since] || since_before[:after]
      state_filters[:before] = since_before[:before]
      self
    end

    def filter_param
      filters = @labels.map {|l| filter('label', l)}
      filters += mutually_exclusive_filters('state', @states) if @states.any?
      filters << 'includedone:true' if @include_done
      filters.join(' ')
    end

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

    def as_msec(datetime)
      datetime.to_i * 1000
    end

  end

end
