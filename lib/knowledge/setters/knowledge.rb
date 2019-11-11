# frozen_string_literal: true

module Knowledge
  module Setters
    # Setter for Knowledge
    #
    # @example
    #   data = { foo: 'bar' }
    #
    #   Knowledge::Setters::Knowledge.new(data: data).call
    #
    #   Knowledge.foo # => "bar"
    class Knowledge < Base
      # Sets all the data
      #
      # @see {#set} for more details
      #
      # @return [Hash] the data
      def call
        @data.each { |name, value| set(name: name, value: value) }
      end

      # Sets a variable on Knowledge::Configuration
      #
      # @param name [Symbol, String]
      # @param value [any]
      def set(name:, value:)
        ::Knowledge::Configuration.setting name, default: value
      end
    end
  end
end
