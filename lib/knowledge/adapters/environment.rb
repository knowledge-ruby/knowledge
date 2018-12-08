# frozen_string_literal: true

module Knowledge
  module Adapters
    #
    # === Description
    #
    # This adapter takes some vars in ENV vars and put it in your project's config.
    #
    # === Usage
    #
    # @example:
    #   # Define your vars with the name of the variable as key and the name of the env var as value
    #   my_vars = { application_token: 'APPLICATION_TOKEN', aws_secret: 'AWS_SECRET_KEY' }
    #
    #   # Instanciate the adapter
    #   adapter = Knowledge::Adapters::Environment.new(setter: MySetter, variables: my_vars)
    #
    #   # And run it
    #   adapter.run
    #
    # === Attributes
    #
    # @attr_reader [Class] setter
    # @attr_reader [Hash] variables
    #
    class Environment < Base
      # == Instance Methods ============================================================================================

      #
      # Runs the actual adapter.
      #
      def run
        variables.each do |name_in_project, name_in_env|
          setter.set(name: name_in_project, value: ENV[name_in_env.to_s])
        end
      end
    end
  end
end
