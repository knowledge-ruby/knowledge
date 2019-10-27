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
      def initialize(data: {})
        @data = data
      end

      def call
        ::Knowledge::Utils.raise_not_callable_parent_method(parent_class: 'Knowledge::Setters::Base')
      end
    end
  end
end
