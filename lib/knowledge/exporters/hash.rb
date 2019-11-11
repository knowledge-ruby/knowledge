# frozen_string_literal: true

module Knowledge
  module Exporters
    # Exports in hashs
    #
    # @example
    #   data = { foo: 'bar' }
    #
    #   result = Knowledge::Exporters::Hash.new(data: data, destination: nil).call
    #
    #   result # => { foo: 'bar' }
    class Hash < Base
      # Returns data as is
      #
      # @return [Hash]
      def call
        @data
      end
    end
  end
end