module PRKit
  class ApiResponse
    def initialize(raw_response)
      @raw_response = raw_response
      @data = nil
    end

    def ok?
      @raw_response.status == 200
    end

    def error?
      !ok?
    end

    def data
      @data ||= JSON.parse(@raw_response.body)
    end

    def stories
      @stories ||= Stories.new(data)
    end

    def count
      data.length
    end
  end
end

