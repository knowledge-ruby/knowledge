# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description
    #
    # This adapter takes some vars in a config object and put it in your project's config.
    # The config object should provide a hash with key=value format.
    #
    # === Usage
    #
    # @example:
    #   # Define your vars with the name of the variable as key and the value as value
    #   my_vars = { application_token: 's3cret', aws_secret: 's3cret' }
    #
    #   # Instanciate the adapter
    #   adapter = Knowledge::Adapters::KeyValue.new(setter: MySetter, variables: my_vars)
    #
    #   # And run it
    #   adapter.run
    #
    # === Attributes
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class KeyValue < Base
      # == Instance Methods ============================================================================================

      #
      # Runs the actual adapter.
      #
      def run
        variables.each { |name, value| setter.set(name: name, value: value) }
      end
    end
  end
end
