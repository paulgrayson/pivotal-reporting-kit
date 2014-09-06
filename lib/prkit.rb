require_relative 'prkit/api_request'
require_relative 'prkit/api_response'
require_relative 'prkit/composite_api_response'
require_relative 'prkit/query'
require_relative 'prkit/context'
require_relative 'prkit/context_project'
require_relative 'prkit/context_account'
require_relative 'prkit/query_project'
require_relative 'prkit/query_account'

module PRKit
  extend self

  attr_accessor :api_token

  def configure(opts={})
    @api_token = opts[:api_token]
  end

end

