require 'bundler/setup'
Bundler.require
require 'active_support/core_ext/numeric/time.rb'
require 'active_support/core_ext/date/calculations.rb'
Dotenv.load

require './lib/api_request'
require './lib/api_response'
require './lib/composite_api_response'
require './lib/query'
require './lib/context'
require './lib/context_project'
require './lib/context_account'
require './lib/query_project'
require './lib/query_account'

puts ENV['PIVOTAL_API_TOKEN']
