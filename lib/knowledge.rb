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
# Funny but quite normal, this gem needs some config.
# If you're familiar with dry-configurable, it should be very understandable for you.
# If not, it's still simple.
#
# You can configure it one by one or all at once:
#
# @example
#
#   Knowledge.config.environment = ENV['RACK_ENV'] || Rails.env || ENV['APP_ENV'] # Or whatever you want
#
#   Knowledge.configure do |config|
#     config.environment = ENV['RACK_ENV'] || Rails.env || ENV['APP_ENV'] # Or whatever you want
#   end
#
# === Usage
#
# @example
#   Knowledge.configure do |config|
#     config.environment = :production
#   end
#
#   # or
#
#   Knowledge.config.environment = :production
#   learner = Knowledge::Learner.new
#   learner.setter = MyCustomProjectVariableSetter
#   learner.variables = 'path/to/config/file'
#
#   # or
#
#   learner.variables = { name: 'value_key' }
#   learner.register_adapter(:custom, MyCustomProjectVariableAdapter, enable: true)
#
#   learner.gather!
#
module Knowledge
  # === Errors
  class UnknownExporter < ArgumentError; end
  class UnknownGetter < ArgumentError; end
  class UnknownSetter < ArgumentError; end

  class NotCallable < NoMethodError; end
  class NotImplemented < NoMethodError; end

  # === Behaviors
  extend Behaviors::Configurable

  # === Use Cases
  include UseCases::LearnFrom
  include UseCases::ExportIn
  include UseCases::ExportLearningsFrom

  # == Settings ========================================================================================================
  setting :environment, default: :development
end
