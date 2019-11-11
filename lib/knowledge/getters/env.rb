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
      # Parses the variables descriptor to map env vars and config variables
      #
      # @example
      #   env_to_config = {
      #     AWS_REGION: :aws_region,
      #     BASIC_AUTH_USER: :basic_auth_username
      #   }
      #   getter = Knowledge::Getters::Env.new(env_to_config)
      #
      #   puts getter.call.inspect
      #   # => {:aws_region=>"us-west-1", :basic_auth_username=>"hello-user"}
      #
      # @return [Hash]
      def call
        @variables.each_with_object({}) do |(env_name, name), result|
          result[name] = ENV[env_name.to_s]

          result
        end
      end
    end
  end
end
