# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description
    #
    # This adapter takes some vars in a config file and put it in your project's config.
    # The config file should provide some YAML with key=value format.
    #
    # It works exactly like the KeyValue adapter, just pass a path to the learner as variables descriptor.
    #
    # === Usage
    #
    # @example:
    #   # Define your vars with the name of the variable as key and the value as value
    #   my_vars = { application_token: 's3cret', aws_secret: 's3cret' }
    #
    #   # Initializes the adapter
    #   adapter = Knowledge::Adapters::File.new(setter: MySetter, variables: my_vars)
    #
    #   # And run it
    #   adapter.run
    #
    # === Attributes
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class File < KeyValue; end
  end
end
