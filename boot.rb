require 'bundler/setup'
Bundler.require
Dotenv.load

require './lib/report'
require './lib/report_response'

puts ENV['PIVOTAL_API_TOKEN']
