module PRKit

  class Api

    API_VERSION = 'v5'
    API_BASE_URI = 'https://www.pivotaltracker.com'

    def connection
      @connection ||= Faraday.new(url: API_BASE_URI) do |faraday|
        faraday.response :logger
        faraday.adapter config.adapter
      end
    end

    def request(path, params)
      full_path = "/services/#{API_VERSION}/#{path}"
      response = connection.get(full_path) do |req|
        req.headers['X-TrackerToken'] = PRKit::api_token
        req.params = params
      end
      response
    end

    # wrap multiple requests in a transaction when they can be executed concurrently
    # responses in a transaction should be regarded as promises until the transaction finishes
    def transaction(&block)
      config.transaction(connection, &block)
    end

    private

    def config
      @config ||= if PRKit::concurrent
        Concurrent.new
      else
        Sequential.new
      end
    end

    class Sequential
      def transaction(connection, &block)
        block.call
      end

      def adapter
        Faraday.default_adapter
      end
    end

    class Concurrent
      require 'typhoeus/adapters/faraday'

      def adapter
        :typhoeus 
      end

      def transaction(connection, &block)
        connection.in_parallel do
          block.call
        end
      end
    end

  end

end
