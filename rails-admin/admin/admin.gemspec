$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "admin"
  s.version     = Admin::VERSION
  s.authors     = ["kimromi"]
  s.email       = ["kimromi4@gmail.com"]
  s.homepage    = "https://github.com/kimromi/memory/tree/master/rails-admin"
  s.summary     = "Test Admin tool"
  s.description = "Test Admin tool"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.9"
  s.add_dependency "slim-rails"
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'cancancan'

  s.add_development_dependency "sqlite3"
end
