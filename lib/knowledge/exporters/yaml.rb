# frozen_string_literal: true

module Knowledge
  module Exporters
    # Exports in YAML
    #
    # @example
    #   data = { foo: 'bar' }
    #
    #   result = Knowledge::Exporters::Yaml.new(data: data, destination: 'tmp/config.yml').call
    #
    #   `cat tmp/config.yml` # => "foo: bar"
    class Yaml < Base
      # Yamlifies data and writes it in a file if destination given
      #
      # @return [String]
      def call
        result = @data.to_yaml

        File.write(@destination, result) if @destination

        result
      end
    end
  end
end
