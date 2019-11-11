# frozen_string_literal: true

require 'knowledge/version'
require 'knowledge/utils'
require 'knowledge/core'
require 'knowledge/behaviors'
require 'knowledge/use_cases'

require 'knowledge/exporters'
require 'knowledge/getters'
require 'knowledge/setters'

require 'knowledge/configuration'

# === Description
#
# Configuration is your project's knowledge, let's make it very simple!
#
# === Configuration
#
# Funny but quite normal, this gem may need some configuration.
# If you're familiar with dry-configurable, it should be very understandable for you.
# If not, it's still simple.
#
# You can configure it one by one or all at once.
#
# @example
#
#   # One variable configuration
#   Knowledge.environment = ENV['RACK_ENV'] || Rails.env || ENV['APP_ENV'] # Or whatever you want
#
# @example
#
#   # Multiple variables configuration
#   Knowledge.configure do |config|
#     config.environment = ENV['RACK_ENV'] || Rails.env || ENV['APP_ENV'] # Or whatever you want
#   end
#
# @example
#
#   # Using a hash to set configuration variables
#   Knowledge.learn_from :hash, variables: { key: :value }
#
#   Knowledge::Configuration.key # => "value"
#
# @example
#
#   # Using a hash to set configuration variables in a given environment
#   variables = {
#     staging: {
#       key: "staging-value"
#     },
#     production: {
#       key: "production-value"
#     }
#   }
#
#   Knowledge.environment = :production
#
#   Knowledge.learn_from :hash, variables: variables
#
#   Knowledge::Configuration.key # => "production-value"
#
# @example
#
#   # Using a file to set configuration variables
#
#   # cat path/to/file.yml
#   #
#   # key: value
#
#   Knowledge.learn_from :yaml, variables: 'path/to/file.yml'
#
#   Knowledge::Configuration.key # => "value"
#
# @example
#
#   # Using a file to set configuration variables in a given environment
#
#   # cat path/to/file.yml
#   #
#   # staging:
#   #   key: staging-value
#   # production:
#   #   key: production-value
#
#   Knowledge.environment = :production
#
#   Knowledge.learn_from :yaml, variables: 'path/to/file.yml'
#
#   Knowledge::Configuration.key # => "production-value"
#
# @example
#
#   # Using ENV to set configuration variables
#
#   # ENV['MY_ENV_VAR'] = 'value'
#
#   Knowledge.learn_from :env, variables: { MY_ENV_VAR: :key }
#
#   Knowledge::Configuration.key # => "value"
module Knowledge
  # === Errors
  class UnknownExporter < ArgumentError; end
  class UnknownGetter < ArgumentError; end
  class UnknownSetter < ArgumentError; end

  class NotCallable < NoMethodError; end
  class NotImplemented < NoMethodError; end

  # === Behaviors
  include Behaviors::Configurable

  # === Use Cases
  include UseCases::LearnFrom
  include UseCases::ExportIn
  include UseCases::ExportLearningsFrom

  # === Settings
  setting :environment, default: :development
end
