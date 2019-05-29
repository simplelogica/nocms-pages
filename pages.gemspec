$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nocms/pages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nocms-pages"
  s.version     = NoCms::Pages::VERSION
  s.authors     = ["Simplelogica"]
  s.email       = ["gems@simplelogica.net"]
  s.homepage    = "https://github.com/simplelogica/nocms-pages"
  s.summary     = "Gem with content page functionality independent from any CMS and embeddable in any Rails 4 app"
  s.description = "Gem with content page functionality independent from any CMS and embeddable in any Rails 4 app"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0", '< 5.1'
  s.add_dependency "globalize", '>= 4.0.0', '< 5.1'
  s.add_dependency "awesome_nested_set", '~> 3.1.3'
  s.add_dependency "nocms-blocks", '~> 1.2.0'

  s.add_development_dependency "sqlite3"
end
