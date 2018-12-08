# frozen_string_literal: true

require 'yaml'

require 'knowledge/configuration'

module Knowledge
  #
  # === Description
  #
  # Object used to backup configuration variables.
  #
  # === Usage
  #
  # @example:
  #
  #   backupper = Knowledge::Backupper.new
  #
  #   backupper.register(name: :foo, value: 'bar')
  #   backupper.register(name: :bar, value: 'baz')
  #
  #   backupper.backup!
  #
  # === Attributes
  #
  # @attr_reader [Hash] configuration
  # @attr_reader [String] path
  #
  class Backupper
    # == Attributes ====================================================================================================

    # Configuration hash
    attr_reader :configuration

    # Backup file path
    attr_reader :path

    # == Constructor ===================================================================================================

    #
    # Just sets the basic configuration object.
    #
    # === Parameters
    #
    # @param :path [String] Path to the YAML file where to backup the config
    #
    def initialize(path:)
      @configuration = {}
      @path = path
    end

    # == Instance methods ==============================================================================================

    #
    # Backups the configuration.
    #
    def backup!
      f = File.new(path, 'w')

      f.write(configuration.to_yaml)

      f.close
    end

    #
    # Sets the variable before backuping everything.
    #
    # === Parameters
    #
    # @param :name [String | Symbol]
    # @param :value [Any]
    #
    def set(name:, value:)
      configuration[name.to_sym] = value
    end
    alias register set
  end
end
