# frozen_string_literal: true

module Knowledge
  #
  # === Description
  #
  # If the project has no defined way to manage its config, why not providing it our way?
  #
  class Configuration
    class << self
      #
      # === Description
      #
      # We're doing black magic (a.k.a metaprogramming) to set variables directly on this class.
      # When programmers do black magic, they should redefine some basic things that are broken as a side effect.
      # That's what happens here. To have a proper inspect, we've got to re-write it manually.
      # It's not something I find very clear but anyway, the API is cool so it's ok for me.
      #
      # It allows us to see every variable that has been defined on the class by metaprogramming.
      #
      # === Usage
      #
      # @example:
      #   # Do some magic before
      #   Knowledge.config.environment = :development
      #   learner = Knowledge::Learner.new
      #
      #   learner.use name: :default
      #   learner.variables = { foo: :bar }
      #
      #   learner.gather!
      #
      #   # And then inspect it
      #   puts Knowledge::Configuration.inspect
      #   # => #<Knowledge::Configuration:0x000047116740290980 @foo="bar">
      #
      #   # Wonderful, isn't it?
      #
      # === Parameters
      #
      # @return [String] as expected
      #
      def inspect
        base = "#<Knowledge::Configuration:0x0000#{object_id}"

        instance_variables.each do |var_name|
          base = "#{base} #{var_name}=\"#{instance_variable_get(var_name)}\""
        end

        "#{base}>"
      end
    end
  end
end
