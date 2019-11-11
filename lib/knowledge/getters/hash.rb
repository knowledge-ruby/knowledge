# frozen_string_literal: true

module Knowledge
  module Getters
    # Getter for hashs
    #
    # @example
    #   config = { foo: 'bar' }
    #
    #   result = Knowledge::Getters::Hash.new(config).call
    #
    #   result # => { foo: 'bar' }
    class Hash < Base
      # Returns the variables as is
      #
      # @return [Hash]
      def call
        @variables
      end
    end
  end
end
