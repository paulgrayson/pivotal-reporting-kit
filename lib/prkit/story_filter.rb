module PRKit
  class StoryFilter
    def label(*labels)
      raise "#{__method__} Not Implemented"
    end

    def status(*status)
      raise "#{__method__} Not Implemented"
    end

    def accepted(since_before=nil)
      raise "#{__method__} Not Implemented"
    end

    def created(since_before=nil)
      raise "#{__method__} Not Implemented"
    end

    def updated(since_before=nil)
      raise "#{__method__} Not Implemented"
    end
  end
end
