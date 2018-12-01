# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Adapters::Environment do
  let(:variables) { { foo: :bar, bar: :baz } }
  let(:setter) { double }

  subject { described_class.new(variables: variables, setter: setter) }

  describe '#run' do
    before do
      ENV['bar'] = 'env_bar'
      ENV['baz'] = 'env_baz'
    end

    it 'sets vars by key => ENV[value]' do
      expect(setter).to receive(:set).with(name: :foo, value: ENV['bar'])
      expect(setter).to receive(:set).with(name: :bar, value: ENV['baz'])

      subject.run
    end
  end
end
