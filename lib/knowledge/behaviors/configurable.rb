# frozen_string_literal: true

require 'forwardable'

module Knowledge
  module Behaviors
    # Configurable behavior provides all necessary tools to make a module or class easily configurable.
    #
    # @example
    #   module Configuration
    #     # Include the configurable behavior
    #     include Knowledge::Behaviors::Configurable
    #
    #     # Create your settings from your module/class directly
    #     setting :foo, default: :bar
    #   end
    #
    #   # Create your settings from outside of your module/class
    #   Configuration.setting :bar, default: :foo
    #   Configuration.setting :baz, default: :bar
    #
    #   # Access your settings by whatever way you want
    #   Configuration.foo # => "bar"
    #   Configuration[:bar] # => "foo"
    #   Configuration['baz'] # => "bar"
    #
    #   # Mutate your settings by whatever way you want
    #   Configuration.baz = 'baz'
    #   Configuration[:foo] = 'baz'
    #   Configuration['bar'] = 'baz'
    #
    #   Configuration.foo # => "baz"
    #   Configuration.bar # => "baz"
    #   Configuration.baz # => "baz"
    #
    #   # Reset everything
    #   Configuration.reset
    module Configurable
      def self.included(base)
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
        # @param default [any, nil] The setting's default / initial value
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
        #   end
        #
        # @yield [Config] the configuration
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

        # Class used to manage the configuration variables
        class Config; end

        # @return [Config]
        def configuration
          @configuration ||= Config.new
        end
      end
    end
  end
end
