# frozen_string_literal: true

module Knowledge
  module Core
    # Knowledge's learner used to retrieve & setup configuration
    class Learner
      # @constructor
      #
      # @param source_type [String, Symbol]
      # @param variables [any]
      # @param setter [String, Symbol]
      #
      # @return {Knowledge::Core::Learner}
      def initialize(source_type:, variables:, setter:)
        @source = ::Knowledge::Utils.camelize(source_type)
        @variables = variables
        @setter = ::Knowledge::Utils.camelize(setter)
      end

      # Learn process
      # - Resolves the getter class
      # - Uses the getter to fetch the configuration variables
      # - Uses the setter to set the configuration variables at the right place
      #
      # @raise {Knowledge::UnknownGetter} if the getter class cannot be resolved
      # @raise {Knowledge::UnknownSetter} if the getter class cannot be resolved
      # @raise {Knowledge::NotCallable} if the getter or setter instance does not respond to #call
      def call
        getter = resolve_getter
        data = getter.call
        setter = resolve_setter(data: data)

        setter.call
      end

      private

      # Resolves the getter class and ensure it's callable
      #
      # @raise {Knowledge::UnknownGetter} if the getter class cannot be resolved
      # @raise {Knowledge::NotCallable} if the getter instance does not respond to #call
      #
      # @return [Class] the getter
      def resolve_getter
        ::Knowledge::Utils.ensure_callable(getter_class.new(@variables))
      end

      # Resolves the setter class and ensure it's callable
      #
      # @raise {Knowledge::UnknownSetter} if the setter class cannot be resolved
      # @raise {Knowledge::NotCallable} if the setter instance does not respond to #call
      #
      # @return [Class] the setter
      def resolve_setter(data:)
        ::Knowledge::Utils.ensure_callable(setter_class.new(data: data))
      end

      # Resolves the getter class
      #
      # @raise {Knowledge::UnknownGetter} if the getter class cannot be resolved
      #
      # @return [Class] the getter class
      def getter_class
        @getter_class ||= ::Knowledge::Utils.resolve_class(
          class_name: @source,
          exception: ::Knowledge::UnknownGetter,
          namespace: ::Knowledge::Getters
        )
      end

      # Resolves the setter class
      #
      # @raise {Knowledge::UnknownSetter} if the setter class cannot be resolved
      #
      # @return [Class] the setter class
      def setter_class
        @setter_class ||= ::Knowledge::Utils.resolve_class(
          class_name: @setter,
          exception: ::Knowledge::UnknownSetter,
          namespace: ::Knowledge::Setters
        )
      end
    end
  end
end
