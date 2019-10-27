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
      def initialize(variables)
        @variables = get_variables_for_current_environment(variables)
      end

      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Getters::Base')
      end

      protected

      def get_variables_for_current_environment(variables)
        environment = ::Knowledge.environment

        return variables unless environment
        return variables unless variables[environment.to_sym] || variables[environment.to_s]

        variables[environment.to_sym] || variables[environment.to_s]
      end
    end
  end
end
