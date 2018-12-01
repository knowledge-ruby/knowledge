# frozen_string_literal: true

require 'yaml'

require 'knowledge/initializer'
require 'knowledge/adapters'
require 'knowledge/setter'

module Knowledge
  #
  # === Description ===
  #
  # Knowledge is something that needs some learning.
  #
  # === Usage ===
  #
  # @example:
  #
  #   learner = Knowledge::Learner.new
  #
  # === Attributes ===
  #
  # @attr_reader [Hash] additionnal_params
  # @attr_reader [Array<String | Symbol>] available_adapters
  # @attr_reader [Array<String | Symbol>] enabled_adapters
  # @attr [Class] setter
  # @attr_reader [Hash] variables
  #
  class Learner
    # == Attributes ==================================================================================================
    attr_accessor :setter
    attr_reader :additionnal_params, :available_adapters, :enabled_adapters, :variables

    # == Constructor =================================================================================================
    def initialize
      @additionnal_params = {}
      @available_adapters = {}
      @enabled_adapters = {}
      @setter = ::Knowledge::Setter.new
    end

    # == Instance methods ============================================================================================
    #
    # === Description ===
    #
    # Gathers all the knowledge and put it into your app.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   # Do some config (add adapters, define your setter, etc.)
    #   learner.gather!
    #
    def gather!
      adapters = enabled_adapters.map { |_name, klass| klass }.compact

      ::Knowledge::Initializer.new(
        adapters: adapters,
        params: additionnal_params,
        setter: setter,
        variables: variables
      ).run
    end

    # == Adapters methods ============================================================================================
    #
    # === Description ===
    #
    # Sets additional params to be passed to the adapter through params option.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.add_adapter_param(name: :base_path, value: '/base/path')
    #
    # === Parameters ===
    #
    # @option [String | Symbol] :name
    # @option [any] :value
    #
    def add_adapter_param(name:, value:)
      @additionnal_params[name] = value
    end

    #
    # === Description ===
    #
    # Disables an adapter.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter, enable: true)
    #   # Somewhere else in the code
    #   learner.disable_adapter(name: :my_adapter) if should_disable_custom_adapter?
    #
    # === Parameters ===
    #
    # @option [String | Symbol] :name
    #
    def disable_adapter(name:)
      @enabled_adapters.delete(name.to_sym)
    end

    #
    # === Description ===
    #
    # Enables an adapter.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter)
    #   learner.enable_adapter(name: :my_adapter)
    #
    # === Errors ===
    #
    # @raises [Knowledge::AdapterNotFound] if adapter is not available
    #
    # === Parameters ===
    #
    # @option [String | Symbol] :name
    #
    def enable_adapter(name:)
      _key, klass = available_adapters.find { |key, _klass| key.to_sym == name.to_sym }

      raise Knowledge::AdapterNotFound, "Cannot find \"#{name}\" in available adapters" if klass.nil?

      @enabled_adapters[name.to_sym] = klass
    end

    #
    # === Description ===
    #
    # Registers an adapter and enable it if asked.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter, enable: true)
    #
    # === Parameters ===
    #
    # @option [String | Symbol] :name
    # @option [Class] :klass
    # @option [Boolean] :enable
    #
    def register_adapter(name:, klass:, enable: false)
      @available_adapters[name.to_sym] = klass
      enable_adapter(name: name) if enable
    end

    #
    # === Description ===
    #
    # Unregisters an adapter and disable it.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.register_adapter(name: :my_adapter, klass: MyAdapter)
    #   # somewhere else in the code
    #   learner.unregister_adapter(name: :my_adapter)
    #
    # === Parameters ===
    #
    # @option [String | Symbol] :name
    #
    def unregister_adapter(name:)
      disable_adapter(name: name)
      @available_adapters.delete(name.to_sym)
    end

    #
    # === Description ===
    #
    # Registers & enables one of the lib's adapters.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.use(name: :ssm)
    #
    # === Parameters ===
    #
    # @option [String | Symbol] name
    # @option [Boolean] enable
    #
    def use(name:, enable: true)
      case name.to_sym
      when :default, :keyval, :key_value
        register_adapter(name: :default, klass: ::Knowledge::Adapters::KeyValue, enable: enable)
      when :env, :environment, :env_vars
        register_adapter(name: :environment, klass: ::Knowledge::Adapters::Environment, enable: enable)
      when :config, :file, :config_file
        register_adapter(name: :file, klass: ::Knowledge::Adapters::File, enable: enable)
      else
        raise ::Knowledge::RegisterError, "Unable to register following: #{name}"
      end
    end

    # == Variables config ============================================================================================
    #
    # === Description ===
    #
    # Setter for the variables config.
    #
    # === Usage ===
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.variables = { name: 'value' }
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.use(name: :env)
    #   learner.variables = { name: 'ENV_KEY' }
    #
    # @example:
    #   learner = Knowledge::Learner.new
    #   learner.variables = 'path/to/vars/config/file.yml'
    #
    # === Errors ===
    #
    # @raise [Knowledge::LearnError] if parameter isn't a hash or a string
    #
    # === Parameters
    #
    # @param [String | Hash] path_or_descriptor
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
    # === Description ===
    #
    # Opens the config file and sets the variable config.
    #
    # === Parameters ===
    #
    # @param [String] path
    #
    def fetch_variables_config(path)
      file_content = ::File.open(path)
      descriptor = ::YAML.safe_load(file_content)
      @variables = descriptor[::Knowledge.config.environment.to_s] || descriptor
    end
  end
end
