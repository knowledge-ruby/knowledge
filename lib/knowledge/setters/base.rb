# frozen_string_literal: true

module Knowledge
  module Setters
    # Base setter
    #
    # @abstract
    #
    # @example
    #   class MySetter < Base
    #     def call
    #       @data.each do |name, value|
    #         my_strategy.set(name: name, value: value)
    #       end
    #     end
    #   end
    class Base
      # @constructor
      #
      # @param data [Hash] data to set
      #
      # @return {Knowledge::Setters::Base}
      def initialize(data: {})
        @data = data
      end

      # Meant to be overridden in the subclasses
      #
      # @raise {Knowledge::NotImplemented} if not overridden
      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Setters::Base')
      end
    end
  end
end
