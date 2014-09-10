require_relative 'prkit/api'
require_relative 'prkit/api_response'
require_relative 'prkit/composite_api_response'
require_relative 'prkit/query'
require_relative 'prkit/context'
require_relative 'prkit/context_project'
require_relative 'prkit/context_account'
require_relative 'prkit/story_filter'
require_relative 'prkit/stories'
require_relative 'prkit/query_project'
require_relative 'prkit/query_account'

module PRKit
  extend self

  attr_reader :api_token, :concurrent

  def configure(opts={})
    @api_token = opts.fetch(:api_token)
    @concurrent = opts.fetch(:concurrent, false)
  end

end

