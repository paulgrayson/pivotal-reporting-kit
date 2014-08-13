require 'bundler/setup'
Bundler.require
require 'active_support/core_ext/numeric/time.rb'
require 'active_support/core_ext/date/calculations.rb'
Dotenv.load

require './lib/report'
require './lib/report_response'
require './lib/pivotal_query'

puts ENV['PIVOTAL_API_TOKEN']
