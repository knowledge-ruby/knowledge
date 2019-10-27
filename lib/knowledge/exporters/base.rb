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
      def initialize(data: {}, destination:)
        @data = data
        @destination = destination
      end

      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Exporters::Base')
      end
    end
  end
end
