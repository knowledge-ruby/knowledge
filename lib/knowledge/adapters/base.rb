# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description
    #
    # This adapter is the base adapter.
    # It does nothing specific but is meant to manage all generic stuff.
    #
    # === Usage
    #
    # Just inherit from it
    #
    # @example:
    #
    #   class MySuperAdapter < Knowledge::Adapters::Base; end
    #
    # === Attributes
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class Base
      # == Attributes ==================================================================================================

      # Setter object used to set variables once retrieved
      attr_reader :setter

      # Variables descriptor
      attr_reader :variables

      # == Constructor =================================================================================================

      #
      # Just initializes instance variables with given params
      #
      # === Parameters
      #
      # @param :variables [Hash]
      # @param :setter [Class]
      # @param :params [Hash]
      #
      def initialize(variables:, setter:, params: nil) # rubocop:disable Lint/UnusedMethodArgument
        @variables = variables
        @setter = setter
      end

      # == Instance Methods ============================================================================================

      #
      # Should run the actual adapter.
      # This method is meant to be overriden
      #
      # === Errors
      #
      # @raise [Knowledge::AdapterRunMethodNotImplemented] if not overridden by subclasses
      #
      def run
        raise ::Knowledge::AdapterRunMethodNotImplemented, "Please override the #run method for #{self.class}"
      end
    end
  end
end
