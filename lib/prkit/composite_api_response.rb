module PRKit
  class CompositeApiResponse
    def initialize(api_responses)
      @api_responses = api_responses
    end

    def ok?
      !error?
    end

    def error?
      @api_responses.any? {|r| r.error?}
    end

    def data
      all = []
      @api_responses.each {|r| all.concat(r.data)}
      all
    end

    # TODO this can be called for non-project responses, where the data is not an array of stories
    # TODO duplicate code from ApiResponse (extend ApiResponse? perhaps make current ApiResponse a concrete subclass)
    def stories
      @stories ||= Stories.new(data)
    end

    def count
      data.length
    end

  end
end
