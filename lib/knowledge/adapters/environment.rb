# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description
    #
    # This adapter takes some vars in ENV vars and put it in your project's config.
    #
    # === Usage
    #
    # @example:
    #   # Define your vars with the name of the variable as key and the name of the env var as value
    #   my_vars = { application_token: 'APPLICATION_TOKEN', aws_secret: 'AWS_SECRET_KEY' }
    #
    #   # Instanciate the adapter
    #   adapter = Knowledge::Adapters::Environment.new(setter: MySetter, variables: my_vars)
    #
    #   # And run it
    #   adapter.run
    #
    # === Attributes
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class Environment < Base
      # == Constructor =================================================================================================

      #
      # Just initializes instance variables with given params
      #
      # === Parameters
      #
      # @param :variables [Hash]
      # @param :setter [Class]
      # @param :params [Hash]
      # @option :params [Boolean] :raise_on_value_not_found
      #
      def initialize(variables:, setter:, params: {})
        super

        @raise_not_found = params[:raise_on_value_not_found] || params['raise_on_value_not_found'] || false
      end

      # == Instance Methods ============================================================================================

      #
      # Runs the actual adapter.
      #
      def run
        variables.each do |name_in_project, (name_in_env, default_value)|
          value = @raise_not_found ? ENV.fetch(name_in_env.to_s) : ENV.fetch(name_in_env.to_s) { default_value }

          setter.set(name: name_in_project, value: value)
        end
      rescue ::KeyError => e
        raise ::Knowledge::ValueNotFound, "[#{e.class}]: #{e.message}"
      end
    end
  end
end
