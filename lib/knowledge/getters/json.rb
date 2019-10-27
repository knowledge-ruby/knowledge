# frozen_string_literal: true

require 'json'

module Knowledge
  module Getters
    # Getter for YAML files
    #
    # @example
    #   # Let's consider foo.json containing `{ "foo": "bar" }`
    #   result = Knowledge::Getters::Json.new('./foo.json').call
    #
    #   result # => { foo: 'bar' }
    class Json < File
      def call
        set_variables(::JSON.parse(::File.read(@path)))

        symbolize_keys(@variables)
      end
    end
  end
end
