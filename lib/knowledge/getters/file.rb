# frozen_string_literal: true

module Knowledge
  module Getters
    # Getter for Files
    #
    # @abstract
    #
    # @example
    #   class MyFileFormat < File
    #     def call
    #       ::Format.parse(File.read(@path))
    #     end
    #   end
    class File < Base
      def initialize(path)
        @path = path
      end

      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Getters::File')
      end

      protected

      def set_variables(variables) # rubocop:disable Naming/AccessorMethodName
        @variables = get_variables_for_current_environment(variables)
      end

      def symbolize_keys(data)
        data.each_with_object({}) do |(key, value), result|
          result[key.to_sym] = value

          result
        end
      end
    end
  end
end
