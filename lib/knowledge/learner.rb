# frozen_string_literal: true

require 'yaml'

require 'knowledge/initializer'
require 'knowledge/adapters'
require 'knowledge/setters'
require 'knowledge/backupper'

module Knowledge
  #
  # === Description
  #
  # Knowledge is something that needs some learning.
  #
  # === Usage
  #
  # @example:
  #
  #   learner = Knowledge::Learner.new
  #
  # === Attributes
  #
  # @attr_reader [Hash] additionnal_params
  # @attr_reader [Hash{Symbol => Class}] available_adapters
  # @attr_reader [Hash{Symbol => Class}] enabled_adapters
  # @attr [Class] setter
  # @attr_reader [Hash] variables
  #
  class Learner
    # == Attributes ====================================================================================================

    # Config variables setter - can be overridden from outside of the object
    attr_accessor :setter

    # Additionnal params to be passed to the adapter
    attr_reader :additionnal_params

    # List of available adapters
    attr_reader :available_adapters

    # List of enabled adapters
    attr_reader :enabled_adapters

    # Descriptor object for the variables to set/fetch
    attr_reader :variables

    # == Constructor ===================================================================================================

    #
    # Just sets default value for instance variables.
    #
    def initialize
      @additionnal_params = {}
      @available_adapters = {}
      @enabled_adapters = {}
      @setter = ::Knowledge::Setters.config.default.new
      @variables = {}
    end

    # == Class methods =================================================================================================
    class << self
      attr_reader :adapters

      #
      # Registers given adapter as a default one.
      # This method is meant to be used only by libraries adding adapters to the lib.
      #
      # @see Knowledge::Learner#use for more details on how details are used.
      #
      # === Usage
      #
      # @example:
      #   # Define your adapter
      #   class SuperServiceAdapter < ::Knowledge::Adapters::Base; end
      #
      #   # Register your adapter
      #   Knowledge::Learner.register_default_adapter(names: %i[super_service service], klass: SuperServiceAdapter)
      #
      #   # Now you can use it the same way every other default adapters
      #   learner = Knowledge::Learner.new
      #
      #   learner.use(name: :super_service)
      #
      # === Parameters
      #
      # @param :names [Array<String | Symbol>] The supported names
      # @param :klass [Class] The actual adapter class
      #
      def register_default_adapter(names:, klass:)
        @adapters ||= {}

        names.each { |name| @adapters[name.to_sym] = klass }
      end
    end

    # == Instance methods ==============================================================================================

    #
    # Gathers all the knowledge and backups it
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   # Do some config (add adapters, define your setter, etc.)
    #
    #   learner.backup!
    #
    # === Parameters
    #
    # @param :path [String] Path to the YAML file where to backup the config
    #
    def backup!(path:)
      backupper = ::Knowledge::Backupper.new(path: path)

      ::Knowledge::Initializer.new(
        adapters: enabled_adapters,
        params: additionnal_params,
        setter: backupper,
        variables: variables
      ).run

      backupper.backup!
    end

    #
    # Gathers all the knowledge and put it into your app.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   # Do some config (add adapters, define your setter, etc.)
    #
    #   learner.gather!
    #
    def gather!
      ::Knowledge::Initializer.new(
        adapters: enabled_adapters,
        params: additionnal_params,
        setter: setter,
        variables: variables
      ).run
    end

    # == Adapters methods ============================================================================================

    #
    # Sets additional params to be passed to the adapter through params option.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.add_adapter_param(adapter: :custom, name: :base_path, value: '/base/path')
    #
    # === Parameters
    #
    # @param :adapter [String | Symbol] The adapter's name
    # @param :name [String | Symbol] The parameter's name
    # @param :value [any] The parameter's value
    #
    def add_adapter_param(adapter:, name:, value:)
      @additionnal_params[adapter.to_sym] ||= {}
      @additionnal_params[adapter.to_sym][name] = value
    end

    #
    # Sets additional params to be passed to the adapter through params option.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.add_adapter_param(name: :base_path, value: '/base/path')
    #
    # === Parameters
    #
    # @param :adapter [String | Symbol] Adapter's name
    # @param :params [any] Params to pass
    #
    def add_adapter_params(adapter:, params:)
      @additionnal_params[adapter.to_sym] = params
    end

    #
    # Disables an adapter.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter, enable: true)
    #
    #   # Somewhere else in the code
    #   learner.disable_adapter(name: :my_adapter) if should_disable_custom_adapter?
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    #
    def disable_adapter(name:)
      @enabled_adapters.delete(name.to_sym)
    end

    #
    # Enables an adapter.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   # Register your adapter
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter)
    #
    #   # Now you can enable it
    #   learner.enable_adapter(name: :my_adapter)
    #
    # === Errors
    #
    # @raises [Knowledge::AdapterNotFound] if adapter is not available
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    # @param :variables [Hash | String | nil]
    #
    def enable_adapter(name:, variables: nil)
      _key, klass = available_adapters.find { |key, _klass| key.to_sym == name.to_sym }

      raise Knowledge::AdapterNotFound, "Cannot find \"#{name}\" in available adapters" if klass.nil?

      @enabled_adapters[name.to_sym] = klass
      set_adapter_variables(name: name, variables: variables)
    end

    #
    # Registers an adapter and enable it if asked.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter, enable: true)
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    # @param :klass [Class]
    # @param :enable [Boolean]
    # @param :variables [Hash | String | nil]
    #
    def register_adapter(name:, klass:, enable: false, variables: nil)
      @available_adapters[name.to_sym] = klass
      enable_adapter(name: name) if enable
      set_adapter_variables(name: name, variables: variables)
    end

    #
    # Sets variables for a given adapter.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.set_adapter_variables(name: :default, variables: { foo: :bar })
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    # @param :variables [Hash | nil]
    #
    def set_adapter_variables(name:, variables: nil)
      return unless variables

      case variables
      when Hash
        set_adapter_variables_by_hash(name: name, variables: variables)
      when String
        set_adapter_variables(name: name, variables: yaml_content(variables))
      else
        raise "Unknown variables type #{variables.class}"
      end
    rescue StandardError => e
      raise ::Knowledge::LearnError, e.message
    end

    #
    # Sets variables as a hash for a given adapter.
    #
    # === Usage
    #
    # @example
    #   learner = Knowledge::Learner.new
    #
    #   learner.set_adapter_variables_by_hash(name: :default, variables: { foo: :bar })
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    # @param :variables [Hash]
    #
    def set_adapter_variables_by_hash(name:, variables:)
      variables = variables[name.to_s] if variables.key?(name.to_s)
      variables = variables[name.to_sym] if variables.key?(name.to_sym)
      @variables[name.to_sym] = variables
    end

    #
    # Unregisters an adapter and disable it.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter)
    #
    #   # somewhere else in the code
    #   learner.unregister_adapter(name: :my_adapter)
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    #
    def unregister_adapter(name:)
      disable_adapter(name: name)
      @available_adapters.delete(name.to_sym)
    end

    #
    # Registers & enables one of the lib's default adapters.
    #
    # If you're writing a gem to add an adapter to knowledge, please have a look at
    # Knowledge::Learned#register_default_adapter
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.use(name: :ssm)
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    # @param :enable [Boolean]
    #
    def use(name:, enable: true)
      adapter = self.class.adapters[name.to_sym]

      raise ::Knowledge::RegisterError, "Unable to register following: #{name}" if adapter.nil?

      register_adapter(name: name.to_sym, klass: adapter, enable: enable)
    end

    # == Variables config ==============================================================================================

    #
    # Setter for the variables config.
    #
    # === Usage
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.variables = { name: 'value' }
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.use(name: :env)
    #
    #   learner.variables = { name: 'ENV_KEY' }
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #
    #   learner.variables = 'path/to/vars/config/file.yml'
    #
    # === Errors
    #
    # @raise [Knowledge::LearnError] if parameter isn't a hash or a string
    #
    # === Parameters
    #
    # @param path_or_descriptor [String | Hash]
    #
    def variables=(path_or_descriptor)
      case path_or_descriptor
      when Hash
        @variables = path_or_descriptor
      when String
        fetch_variables_config(path_or_descriptor)
      else
        raise ::Knowledge::LearnError, "Unable to understand following path or descriptor: #{path_or_descriptor}"
      end
    end

    protected

    #
    # Opens the config file and sets the variable config.
    #
    # === Parameters
    #
    # @param path [String]
    #
    def fetch_variables_config(path)
      descriptor = yaml_content(path)
      @variables = descriptor[::Knowledge.config.environment.to_s] || descriptor
    end

    #
    # Loads YAML file content.
    #
    # === Parameters
    #
    # @param path [String]
    #
    # @return [Hash]
    #
    def yaml_content(path)
      ::YAML.safe_load(::File.open(path))
    end
  end
end

# Registering default adapters

Knowledge::Learner.register_default_adapter(
  klass: Knowledge::Adapters::Environment,
  names: %i[env environment env_vars]
)

Knowledge::Learner.register_default_adapter(
  klass: Knowledge::Adapters::KeyValue,
  names: %i[default keyval key_value]
)

Knowledge::Learner.register_default_adapter(
  klass: Knowledge::Adapters::File,
  names: %i[config file config_file]
)
