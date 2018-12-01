# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Configuration do
  describe '#inspect' do
    it 'prints defined vars while inspecting' do
      # Let's set some vars so that we can check it's printed
      ::Knowledge::Setter.new.set(name: :foo, value: :bar)

      expect(described_class.inspect).to include('@foo="bar"')
    end
  end
end
