# frozen_string_literal: true

module Knowledge
  module UseCases
    # Use Case "Export In"
    #
    # Provides ability to export configuration in a given format and to a potential destination
    #
    # @example
    #   Knowledge.export_in :json, destination: 'tmp/backups/project_config.json'
    module ExportIn
      def self.included(base)
        base.extend(ClassMethods)
      end

      # :nodoc:
      module ClassMethods
        # Exports the current configuration in a given format
        #
        # @example
        #   export_in :json, destination: '/path/to/exported-config.json'
        #
        # @param type [String, Symbol]
        # @param destination [any] Whatever is required by the exporter strategy to be able to export to the destination
        def export_in(type, destination: nil)
          ::Knowledge::Core::Exporter.new(type: type, destination: destination, data: export).call
        end

        private

        # Exports the current configuration into a Hash
        #
        # @return [Hash]
        def export
          config_to_export = Knowledge::Configuration.send(:configuration)

          config_to_export.instance_variables.each_with_object({}) do |name, result|
            sanitized_name = name.to_s.delete('@').to_sym
            result[sanitized_name] = config_to_export.public_send(sanitized_name)

            result
          end
        end
      end
    end
  end
end
