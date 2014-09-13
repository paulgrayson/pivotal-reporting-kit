module PRKit
  class Config

    def self.configure(opts={})
      @api_token = opts.fetch(:api_token)
      @concurrent = opts.fetch(:concurrent, false)
    end

    USAGE = 'PRKit not configured with Pivotal Tracker API token. '+
            'Use `PRKit::configure(api_token: "<the token>")`'

    def self.ensure_configured!
      raise USAGE if @api_token.nil?
    end

    def self.api_token
      @api_token
    end

    def self.concurrent
      @concurrent
    end

  end
end

