# frozen_string_literal: true

module Knowledge
  module UseCases
    # Use Case "Export In"
    #
    # Provides ability to get configuration from where it is and set it up in the project
    #
    # @example
    #   Knowledge.learn_from :hash, variables: { foo: 'bar' }
    #
    #   Knowledge::Configuration.foo # => "bar"
    module LearnFrom
      def self.included(base)
        base.extend(ClassMethods)
      end

      # :nodoc:
      module ClassMethods
        # Uses a getter strategy to resolve variables and a setter strategy to build the current config out of it.
        #
        # @param source_type [String, Symbol]
        # @param variables [any] Whatever is required by the getter strategy to be able to resolve the variables
        # @param setter [String, Symbol] Setter strategy to use
        def learn_from(source_type, variables: nil, setter: :default)
          ::Knowledge::Core::Learner.new(source_type: source_type, variables: variables, setter: setter).call
        end
      end
    end
  end
end
