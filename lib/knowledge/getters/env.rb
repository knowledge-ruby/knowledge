# frozen_string_literal: true

module Knowledge
  module Getters
    # Getter for environment variables
    #
    # @example
    #   ENV['MY_CONFIG_VAR'] = 'foo'
    #
    #   result = Knowledge::Getters::Env.new({ MY_CONFIG_VAR: 'super_config' }).call
    #
    #   result # => { my_super_config: 'foo' }
    class Env < Base
      def call
        @variables.each_with_object({}) do |(env_name, name), result|
          result[name] = ENV[env_name.to_s]

          result
        end
      end
    end
  end
end
