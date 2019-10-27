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
      def call
        @data.each { |name, value| set(name: name, value: value) }
      end

      def set(name:, value:)
        ::Knowledge::Configuration.setting name, default: value
      end
    end
  end
end
