# frozen_string_literal: true

module Knowledge
  #
  # === Description
  #
  # We all need an initializer, here's this lib's initializer.
  # Its role is to gather all informations and run the enabled adapters.
  #
  # === Usage
  #
  # @example:
  #   Knowledge::Initializer.new(adapters: adapters, params: { foo: :bar }, setter: setter, variables: variables).run
  #
  #   # or
  #
  #   Knowledge::Initializer.run(adapters: adapters, params: { foo: :bar }, setter: setter, variables: variables)
  #
  # === Attributes
  #
  # @attr_reader [Array<String | Symbol>] adapters
  # @attr_reader [Hash] params
  # @attr_reader [Class] setter
  # @attr_reader [Hash] variables
  #
  class Initializer
    # == Attributes ====================================================================================================

    # Adapters that will be used to retrieve variables' values
    attr_reader :adapters

    # Additionnal parameters to pass to the adapters
    attr_reader :params

    # Setter used to set variables after having retrieved their values
    attr_reader :setter

    # Descriptor for the variables to retrieve/fetch
    attr_reader :variables

    # == Constructor =================================================================================================

    #
    # Just initializes instance variables with given params.
    #
    # === Parameters
    #
    # @param :adapters [Array<Class>]
    # @param :params [Hash]
    # @param :setter [Class]
    # @param :variables [Hash]
    #
    def initialize(adapters:, params:, setter:, variables:)
      @adapters = adapters
      @params = params
      @setter = setter
      @variables = variables
    end

    # == Class methods ===============================================================================================
    class << self
      #
      # Instanciates the current class and runs all registered adapters.
      #
      # === Parameters
      #
      # @param :adapters [Hash{Symbol => Class}]
      # @param :params [Hash]
      # @param :setter [Class]
      # @param :variables [Hash]
      #
      def run(adapters:, params:, setter:, variables: {})
        new(adapters: adapters, params: params, setter: setter, variables: variables).run
      end
    end

    # == Instance methods ============================================================================================

    #
    # Runs all registered adapters.
    #
    def run
      Hash(adapters).each do |name, adapter|
        adapter.new(
          params: params[name.to_sym] || params,
          setter: setter,
          variables: variables[name.to_sym] || variables
        ).run
      end
    end
  end
end
