# frozen_string_literal: true

require 'knowledge/configuration'

module Knowledge
  module Setters
    #
    # === Description
    #
    # This adapter is the base setter.
    # It does nothing specific but is meant to manage all generic stuff.
    #
    # === Usage
    #
    # Just inherit from it
    #
    # @example:
    #
    #   class MySuperSetter < Knowledge::Setters::Base; end
    #
    # === Attributes
    #
    # @attr_reader [Class | Hash | Object] configuration
    #
    class Base
      # == Attributes ==================================================================================================

      # Configuration object - can be whetever your setter knows how to work with
      attr_reader :configuration

      # == Instance methods ============================================================================================

      #
      # Sets the variable.
      #
      # === Parameters
      #
      # @param :name [String | Symbol]
      # @param :value [Any]
      #
      def set(name:, value:)
        error_message = "Expect setter to define #set method to be able to set #{name} with value '#{value}'"
        raise ::Knowledge::SetterSetMethodNotImplemented, error_message
      end
    end
  end
end
