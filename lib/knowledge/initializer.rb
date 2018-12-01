# frozen_string_literal: true

module Knowledge
  #
  # === Description ===
  #
  # We all need an initializer, here's this lib's initializer.
  # Its role is to gather all informations and run the enabled adapters.
  #
  # === Usage ===
  #
  # @example:
  #   Knowledge::Initializer.new(adapters: adapters, params: { foo: :bar }, setter: setter, variables: variables).run
  #
  #   Knowledge::Initializer.run(adapters: adapters, params: { foo: :bar }, setter: setter, variables: variables)
  #
  # === Attributes ===
  #
  # @attr_reader [Array<String | Symbol>] adapters
  # @attr_reader [Hash] params
  # @attr_reader [Class] setter
  # @attr_reader [Hash] variables
  #
  class Initializer
    # == Attributes ==================================================================================================
    attr_reader :adapters, :params, :setter, :variables

    # == Constructor =================================================================================================
    #
    # @option [Array<Class>] :adapters
    # @option [Hash] :params
    # @option [Class] :setter
    # @option [Hash] :variables
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
      # === Description ===
      #
      # Instanciates the current class and runs all registered adapters.
      #
      # === Parameters ===
      #
      # @option [Array<Class>] :adapters
      # @option [Hash] :params
      # @option [Class] :setter
      # @option [Hash] :variables
      #
      def run(adapters:, params:, setter:, variables: {})
        new(adapters: adapters, params: params, setter: setter, variables: variables).run
      end
    end

    # == Instance methods ============================================================================================
    #
    # === Description ===
    #
    # Runs all registered adapters.
    #
    def run
      Array(adapters).each do |adapter|
        adapter.new(
          params: params,
          setter: setter,
          variables: variables
        ).run
      end
    end
  end
end
