# frozen_string_literal: true

module Knowledge
  module Setters
    # Setter used to export data
    #
    # @example
    #   data = { foo: 'bar' }
    #
    #   Knowledge::Setters::Exporter.new(data: data).call # => { foo: 'bar' }
    class Exporter < Base
      # Returns the variables as is
      #
      # @return [Hash]
      def call
        @data
      end
    end
  end
end
