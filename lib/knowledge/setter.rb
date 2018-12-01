# frozen_string_literal: true

require 'knowledge/configuration'

module Knowledge
  #
  # === Description ===
  #
  # If you don't have a defined strategy to manage config for your project, you can use Knowledge's one.
  # This is the custom setter
  #
  # === Usage ===
  #
  # @example:
  #   Knowledge::Setter.new.set(name: :foo, value: 'bar')
  #
  class Setter
    # == Constructor ===================================================================================================
    def initialize
      @configuration = ::Knowledge::Configuration
    end

    # == Instance methods ==============================================================================================
    #
    # === Description ===
    #
    # Sets the variable by doing black magic on Knowledge::Configuration
    #
    # === Parameters ===
    #
    # @option [String | Symbol] :name
    # @option [Any] :value
    #
    def set(name:, value:)
      @configuration.singleton_class.class_eval { attr_accessor name.to_sym } unless @configuration.respond_to?(name)
      @configuration.instance_variable_set(:"@#{name}", value)
    end
  end
end
