# frozen_string_literal: true

module Knowledge
  module Core
    # Knowledge's learner used to retrieve & setup configuration
    class Learner
      def initialize(source_type:, variables:, setter:)
        @source = ::Knowledge::Utils.camelize(source_type)
        @variables = variables
        @setter = ::Knowledge::Utils.camelize(setter)
      end

      def call
        getter = resolve_getter
        data = getter.call
        setter = resolve_setter(data: data)

        setter.call
      end

      private

      def resolve_getter
        ::Knowledge::Utils.ensure_callable(getter_class.new(@variables))
      end

      def resolve_setter(data:)
        ::Knowledge::Utils.ensure_callable(setter_class.new(data: data))
      end

      def getter_class
        @getter_class ||= ::Knowledge::Utils.resolve_class(
          class_name: @source,
          exception: ::Knowledge::UnknownGetter,
          namespace: ::Knowledge::Getters
        )
      end

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
