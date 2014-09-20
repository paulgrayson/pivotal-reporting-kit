# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prkit/version'

Gem::Specification.new do |s|
  s.name        = 'prkit'
  s.version     = PRKit::VERSION
  s.date        = '2014-09-13'
  s.summary     = "PRKit - Pivotal Tracker Reporting Kit, ruby client for PT's v5 API"
  s.description =
    "PRKit provides a client for querying PT's v5 API."+
    "\nPRKit optionally supports concurrent requests using Typhoeus."+
    "\nPRKit can run a query across one, several or all projects in a PT account."
  s.authors     = ["Paul Grayson"]
  s.files       = Dir.glob("{bin,lib}/**/*") + ['README.md', 'LICENSE.txt']
  s.homepage    = 'https://github.com/paulgrayson/pivotal-reporting-kit'
  s.license     = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'dotenv'
  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'json'

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'typhoeus'
end
