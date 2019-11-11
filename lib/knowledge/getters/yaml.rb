# frozen_string_literal: true

require 'yaml'

module Knowledge
  module Getters
    # Getter for YAML files
    #
    # @example
    #   # Let's consider foo.yml containing `foo: bar`
    #   result = Knowledge::Getters::Yaml.new('./foo.yml').call
    #
    #   result # => { foo: 'bar' }
    class Yaml < File
      # Reads the file, sets and returns the variables
      #
      # @return [Hash]
      def call
        set_variables(::YAML.load_file(@path))

        ::Knowledge::Utils.symbolize_keys(@variables)
      end
    end
  end
end
