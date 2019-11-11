# frozen_string_literal: true

module Knowledge
  module Exporters
    # Base exporter
    #
    # @abstract
    #
    # @example
    #   class MyExporter < Base
    #     def call
    #       File.write(format(@data), @destination)
    #     end
    #   end
    class Base
      # @constructor
      #
      # @param data [Hash] Set of data to be exported
      # @param destination [any] Whatever is required by the exporter strategy to be able to export to the destination
      #
      # @return {Knowledge::Exporters::Base}
      def initialize(data: {}, destination:)
        @data = data
        @destination = destination
      end

      # Meant to be overridden in the subclasses
      #
      # @raise {Knowledge::NotImplemented} if not overridden
      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Exporters::Base')
      end
    end
  end
end
