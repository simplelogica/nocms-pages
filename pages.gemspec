$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nocms/pages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nocms-pages"
  s.version     = NoCMS::Pages::VERSION
  s.authors     = ["David J. Brenes"]
  s.email       = ["david.brenes@simplelogica.net"]
  s.homepage    = "http://www.simplelogica.net"
  s.summary     = "Gem with content page functionality independent from any CMS and embeddable in any Rails 4 app"
  s.description = "Gem with content page functionality independent from any CMS and embeddable in any Rails 4 app"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency "globalize", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
