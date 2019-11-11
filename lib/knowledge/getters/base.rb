# frozen_string_literal: true

module Knowledge
  module Getters
    # Base getter
    #
    # @abstract
    #
    # @example
    #   class MyGetter < Base
    #     def call
    #       @variables.dup
    #     end
    #   end
    class Base
      # @constructor
      #
      # @param variables [Hash] variables or variables descriptor needed to get the variables
      #
      # @return {Knowledge::Getters::Base}
      def initialize(variables)
        @variables = get_variables_for_current_environment(variables)
      end

      # Meant to be overridden in the subclasses
      #
      # @raise {Knowledge::NotImplemented} if not overridden
      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Getters::Base')
      end

      protected

      # If an environment is set, search for a root key corresponding to the environment name
      # Otherwise or if root key not found, returns variables as is
      #
      # @param variables [Hash]
      #
      # @return [Hash]
      def get_variables_for_current_environment(variables)
        environment = ::Knowledge.environment

        return variables unless environment
        return variables unless variables[environment.to_sym] || variables[environment.to_s]

        variables[environment.to_sym] || variables[environment.to_s]
      end
    end
  end
end
