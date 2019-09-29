# frozen_string_literal: true

module Knowledge
  #
  # === Description
  #
  # Internal configuration module providing required DSL to be able to manage internal configuration.
  #
  # === Usage
  #
  # @example
  #   module MyModule
  #     extend Configurable
  #
  #     setting :variable, default: :default_value
  #   end
  #
  #   MyModule.variable # :default_value
  #
  #   MyModule.configure do |config|
  #     config.variable = :foo
  #   end
  #
  #   MyModule.variable # :foo
  #
  #   MyModule.variable = :bar
  #
  #   MyModule.variable # :bar
  #
  module Configurable
    def self.extended(base)
      base.singleton_class.extend(Forwardable)
      base.extend(ClassMethods)
    end

    #
    # Class Methods to be injected.
    #
    module ClassMethods
      #
      # Registers a configuration variable with a potential default value
      #
      # === Usage
      #
      # @example
      #
      #   setting :my_config
      #   setting :environment, default: :development
      #
      # === Parameters
      #
      # @param name [String, Symbol] the variable's name
      # @param default [any] default value for the variable to define
      #
      def setting(name, default: nil)
        configuration.class.send(:attr_accessor, name)
        configuration.public_send("#{name}=", default)

        singleton_class.class_eval { def_delegators :configuration, name, "#{name}=" }
      end

      #
      # Exposes the configuration allowing to manage it.
      #
      # === Usage
      #
      # @example
      #
      #   MyModule.configure do |config|
      #     config.my_variable = :foo
      #   end
      #
      # === Parameters
      #
      # @yield configuration [Config]
      #
      def configure
        yield configuration
      end

      #
      # Syntaxic sugar allowing to access a config var.
      #
      # === Usage
      #
      # @example
      #
      #   MyModule[:my_variable] # :foo
      #
      # === Parameters
      #
      # @param name [String, Symbol]
      #
      # @return the value of the config var
      #
      def [](name)
        configuration.public_send(name.to_sym)
      end

      #
      # Syntaxic sugar allowing to set a config var.
      #
      # === Usage
      #
      # @example
      #
      #   MyModule[:my_variable] = :foo # :foo
      #
      # === Parameters
      #
      # @param name [String, Symbol]
      # @param value [any]
      #
      # @return the value of the config var
      #
      def []=(name, value)
        configuration.public_send("#{name}=", value)
      end

      private

      #
      # === Description
      #
      # Used for storing the configuration variables in order not to leak it into Class
      #
      class Config; end

      # @return [Config]
      def configuration
        @configuration ||= Config.new
      end
    end
  end
end
