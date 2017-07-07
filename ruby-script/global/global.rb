# gem install global
require 'global'

Global.environment = ENV['ENVIRONMENT'] || 'development'
Global.config_directory = __dir__

# read hello.yml
puts Global.hello.message
