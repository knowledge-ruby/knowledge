# frozen_string_literal: true

module Knowledge
  module Setters
    # Default setter
    #
    # @example
    #   data = { foo: 'bar' }
    #
    #   Knowledge::Setters::Default.new(data: data).call
    #
    #   Knowledge.foo # => "bar"
    class Default < Knowledge
    end
  end
end
