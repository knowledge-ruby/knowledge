# frozen_string_literal: true

module Knowledge
  # utilities used accross the lib
  class Utils
    class << self
      def camelize(str)
        str.to_s.split(/_|-/).map(&:capitalize).join
      end

      def resolve_class(namespace:, class_name:, exception:)
        result = namespace.const_get(class_name)

        raise exception, "Cannot find #{namespace}::#{class_name}" unless result.is_a?(Class)

        result
      rescue ::NameError
        raise exception, "Cannot find #{namespace}::#{class_name}"
      end

      def ensure_callable(object)
        raise ::Knowledge::NotCallable, "undefined method 'call' for #{object}" unless object.respond_to?(:call)

        object
      end

      def raise_not_callable_parent_method(parent_class:)
        message = "#{parent_class} is not meant to be used directly, please override 'call' method in children classes."

        raise ::Knowledge::NotImplemented, message
      end
    end
  end
end
