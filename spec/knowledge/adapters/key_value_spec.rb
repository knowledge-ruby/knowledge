# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Adapters::KeyValue do
  let(:variables) { { foo: :bar, bar: :baz } }
  let(:setter) { double }

  subject { described_class.new(variables: variables, setter: setter) }

  describe '#run' do
    it 'sets vars by key => value' do
      expect(setter).to receive(:set).with(name: :foo, value: :bar)
      expect(setter).to receive(:set).with(name: :bar, value: :baz)

      subject.run
    end
  end
end
