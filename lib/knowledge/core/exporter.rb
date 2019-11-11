# frozen_string_literal: true

module Knowledge
  module Core
    # Knowledge's core exporter is designed to backup the configuration using strategies.
    # All export strategies can be found under {Knowledge::Exporters}'s namespace.
    #
    # @example
    #   Knowledge::Core::Exporter.new(type: 'json', destination: '/path/to/export.json', data: { hello: 'world' }).call
    class Exporter
      # @constructor
      #
      # @param type [String, Symbol] Export type corresponding to exporter strategy's class name
      # @param destination [any] Whatever is required by the exporter strategy to be able to export to the destination
      # @param data [Hash] Set of data to be exported
      #
      # @return {Knowledge::Core::Exporter}
      def initialize(type:, destination:, data:)
        @type = ::Knowledge::Utils.camelize(type)
        @destination = destination
        @data = data
      end

      # :nodoc:
      def call
        @exporter = resolve_exporter

        @exporter.call
      end

      # Sets missing instance variables and exports data
      #
      # @param type [String, Symbol] Export type corresponding to exporter strategy's class
      # @param destination [any] Whatever is required by the exporter strategy to be able to export to the destination
      def in(type, destination:)
        @type = ::Knowledge::Utils.camelize(type)
        @destination = destination

        call
      end

      private

      # Finds the right strategy and ensure it's callable
      #
      # @raise {Knowledge::NotCallable} if the strategy's instance does not respond to call
      #
      # @return an instanciated strategy inheriting from {Knowledge::Exporters::Base}
      def resolve_exporter
        ::Knowledge::Utils.ensure_callable(exporter_class.new(data: @data, destination: @destination))
      end

      # Resolves the strategy in {Knowledge::Exporters} namespace and ensures it's a class
      #
      # @raise {Knowledge::UnknownExporter} if the strategy cannot be found
      # @raise {Knowledge::UnknownExporter} if the strategy is not a class
      #
      # @return a strategy inheriting from {Knowledge::Exporters::Base}
      def exporter_class
        @exporter_class ||= ::Knowledge::Utils.resolve_class(
          class_name: @type,
          exception: ::Knowledge::UnknownExporter,
          namespace: ::Knowledge::Exporters
        )
      end
    end
  end
end
