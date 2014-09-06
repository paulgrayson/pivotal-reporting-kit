require 'bundler/setup'
Bundler.require
require 'active_support/core_ext/numeric/time.rb'
require 'active_support/core_ext/date/calculations.rb'
Dotenv.load

require './lib/prkit'
