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
      # @constructor
      #
      # @param path [String] path from where to get the variables
      #
      # @return {Knowledge::Getters::File}
      def initialize(path)
        @path = path
      end

      # Meant to be overridden in the subclasses
      #
      # @raise {Knowledge::NotImplemented} if not overridden
      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Getters::File')
      end

      protected

      # Setter for variables
      # This method is used to make the call to {#get_variables_for_current_environment} transparent
      #
      # @param variables [Hash]
      def set_variables(variables) # rubocop:disable Naming/AccessorMethodName
        @variables = get_variables_for_current_environment(variables)
      end
    end
  end
end
