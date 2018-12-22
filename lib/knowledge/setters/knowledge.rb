# frozen_string_literal: true

require 'knowledge/configuration'

module Knowledge
  module Setters
    #
    # === Description
    #
    # If you don't have a defined strategy to manage config for your project, you can use Knowledge's one.
    # This is the custom setter.
    #
    # === Usage
    #
    # @example:
    #
    #   Knowledge::Setters::Knowledge.new.set(name: :foo, value: 'bar')
    #
    # === Attributes
    #
    # @attr_reader [Knowledge::Configuration] configuration
    #
    class Knowledge < Base
      # == Constructor =================================================================================================

      #
      # Just sets the basic configuration object.
      #
      def initialize
        @configuration = ::Knowledge::Configuration
      end

      # == Instance methods ============================================================================================

      #
      # Sets the variable by doing black magic on Knowledge::Configuration.
      #
      # === Parameters
      #
      # @param :name [String | Symbol]
      # @param :value [Any]
      #
      def set(name:, value:)
        @configuration.singleton_class.class_eval { attr_accessor name.to_sym } unless @configuration.respond_to?(name)
        @configuration.instance_variable_set(:"@#{name}", value)
      end
    end
  end
end
