# frozen_string_literal: true

module Knowledge
  module UseCases
    # Use Case "Export Learnings From"
    #
    # Provides ability to get configuration and export it in a given format and to a potential destination
    #
    # @example
    #   Knowledge.export_learnings_from(
    #     :yaml,
    #     variables: './tmp/variables.yml'
    #   ).in(
    #     :json,
    #     destination: 'tmp/backups/project_config.json'
    #   )
    module ExportLearningsFrom
      def self.included(base)
        base.extend(ClassMethods)
      end

      # :nodoc:
      module ClassMethods
        # Exports a configuration in a given format.
        # This method is meant to be combined with {Knowledge::Core::Exporter#in}.
        #
        # @see {Knowledge::Core::Exporter#in}
        #
        # @example
        #   export_learnings_from(:hash, variables: { foo: 'bar' }).in(:json, destination: '/path/to/export.json')
        #
        # @param source_type [String, Symbol]
        # @param variables [any] Whatever is required by the getter strategy to be able to resolve the variables
        def export_learnings_from(source_type, variables:)
          data = ::Knowledge::Core::Learner.new(source_type: source_type, variables: variables, setter: :exporter).call

          ::Knowledge::Core::Exporter.new(type: nil, destination: nil, data: data)
        end
      end
    end
  end
end
