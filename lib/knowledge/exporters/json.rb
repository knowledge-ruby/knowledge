# frozen_string_literal: true

module Knowledge
  module Exporters
    # Exports in JSON
    #
    # @example
    #   data = { foo: 'bar' }
    #
    #   result = Knowledge::Exporters::Json.new(data: data, destination: 'tmp/config.json').call
    #
    #   `cat tmp/config.json` # => "{\"foo\":\"bar\"}"
    class Json < Base
      # Jsonifies data and writes it in a file if destination given
      #
      # @return [String]
      def call
        result = @data.to_json

        File.write(@destination, result) if @destination

        result
      end
    end
  end
end
