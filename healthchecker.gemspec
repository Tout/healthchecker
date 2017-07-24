$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "healthchecker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "healthchecker"
  s.version     = Healthchecker::VERSION
  s.authors     = ['Will Bryant']
  s.email       = ['william@tout.com']
  s.homepage    = 'http://github.com/Tout/healthchecker'
  s.summary     = "Standardized, healthcheck end-point for rails apps"
  s.description = "Standardized, healthcheck end-point for rails apps"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.required_ruby_version = '>= 1.9.3'
  s.add_dependency(%q<rails>, [">= 4.0"])

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'redis'
  s.add_development_dependency 'aws-sdk'
  s.add_development_dependency 'simplecov'
end
