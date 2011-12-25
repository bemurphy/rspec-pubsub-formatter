# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "rspec-pubsub-formatter/version"

Gem::Specification.new do |s|
  s.name        = "rspec-pubsub-formatter"
  s.version     = Rspec::Pubsub::Formatter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brendon Murphy"]
  s.email       = ["xternal1+github@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Publish rspec status from a spec run into redis}
  s.description = s.summary

  s.rubyforge_project = "rspec-pubsub-formatter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "rspec", ">= 2"
  s.add_dependency "redis", "~> 2.2.2"
  s.add_dependency "json"
end
