# frozen_string_literal: true

require 'forwardable'

module Knowledge
  module Behaviors
    # Configurable behavior provides all necessary tools to make a module or class easily configurable.
    #
    # @example
    #   module Configuration
    #     include Knowledge::Behaviors::Configurable
    #
    #     setting :foo, default: :bar
    #   end
    #
    #   Configuration.setting :bar, default: :foo
    #   Configuration.setting :baz, default: :bar
    #
    #   Configuration.foo # => "bar"
    #   Configuration[:bar] # => "foo"
    #   Configuration['baz'] # => "bar"
    #
    #   Configuration.baz = 'baz'
    #   Configuration[:foo] = 'baz'
    #   Configuration['bar'] = 'baz'
    #
    #   Configuration.foo # => "baz"
    #   Configuration.bar # => "baz"
    #   Configuration.baz # => "baz"
    #
    #   Configuration.reset
    module Configurable
      def self.extended(base)
        base.singleton_class.extend(Forwardable)
        base.extend(ClassMethods)
      end

      # :nodoc:
      module ClassMethods
        # Creates a setting on the configuration
        #
        # @example
        #   Configuration.setting :foo, default: 'bar'
        #
        #   Configuration.foo # => "bar"
        #
        # @param name [String, Symbol] The setting's name
        # @param default [any]
        def setting(name, default: nil)
          configuration.class.send(:attr_accessor, name)
          configuration.public_send("#{name}=", default)

          singleton_class.class_eval { def_delegators :configuration, name, "#{name}=" }
        end

        # Interface provided to update config's vars
        #
        # @example
        #   Configuration.configure do |config|
        #     config.foo = 'bar' # => "bar"
        #     config.unexisting_attribute = 'foo' # NoMethodError
        #
        # @yield [Class] the configuration
        def configure
          yield configuration
        end

        # Resets the configuration
        #
        # @example
        #   Configuration.setting :foo, default: :bar
        #
        #   Configuration.foo # => "bar"
        #
        #   Configuration.reset
        #
        #   Configuration.foo # NoMethodError
        def reset
          @configuration = Config.new
        end

        # Getter
        #
        # @param name [String]
        #
        # @return the configuration value
        def [](name)
          configuration.public_send(name.to_sym)
        end

        # Setter
        #
        # @param name [String]
        # @param value [any]
        #
        # @return the new configuration value
        def []=(name, value)
          configuration.public_send("#{name}=", value)
        end

        private

        # :nodoc:
        class Config; end

        # :nodoc:
        def configuration
          @configuration ||= Config.new
        end
      end
    end
  end
end
