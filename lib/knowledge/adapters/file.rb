# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description ===
    #
    # This adapter takes some vars in a config file and put it in your project's config.
    # The config file should provide some YAML with key=value format.
    #
    # === Usage ===
    #
    # @example:
    #   adapter = Knowledge::Adapters::File.new(setter: MySetter, variables: my_vars)
    #
    #   adapter.run
    #
    # === Attributes ===
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class File < KeyValue; end
  end
end
