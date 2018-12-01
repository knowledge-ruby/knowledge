# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description ===
    #
    # This adapter is the base adapter.
    # It does nothing specific but is meant to manage all generic stuff.
    #
    # === Usage ===
    #
    # Just inherit from it
    #
    # === Attributes ===
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class Base
      # == Attributes ==================================================================================================
      attr_reader :setter, :variables

      # == Constructor =================================================================================================
      #
      # @option [Hash] :variables
      # @option [Class] :setter
      # @option [Hash] :params
      #
      def initialize(variables:, setter:, params: nil) # rubocop:disable Lint/UnusedMethodArgument
        @variables = variables
        @setter = setter
      end

      # == Instance Methods ============================================================================================
      #
      # === Description ===
      #
      # Should run the actual adapter.
      # This method is meant to be overriden
      #
      # === Errors ===
      #
      # @raise [Knowledge::AdapterRunMethodNotImplemented] if not overridden by subclasses
      #
      def run
        raise ::Knowledge::AdapterRunMethodNotImplemented, "Please override the #run method for #{self.class}"
      end
    end
  end
end
