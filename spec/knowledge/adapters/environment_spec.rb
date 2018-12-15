# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Adapters::Environment do
  let(:variables) { { foo: :bar, bar: :baz } }
  let(:setter) { double }

  subject { described_class.new(variables: variables, setter: setter) }

  describe '#run' do
    before do
      ENV.delete('bar')
      ENV.delete('baz')
    end

    context 'working case' do
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

    context 'not raise on value not found' do
      before { ENV['bar'] = 'env_bar' }

      it 'sets vars by key => ENV[value] and fallbacks to nil' do
        expect(setter).to receive(:set).with(name: :foo, value: ENV['bar'])
        expect(setter).to receive(:set).with(name: :bar, value: nil)

        subject.run
      end
    end

    context 'raise on value not found' do
      subject { described_class.new(variables: variables, setter: setter, params: { raise_on_value_not_found: true }) }

      before { ENV['bar'] = 'env_bar' }

      it 'raises a KeyError' do
        expect(setter).to receive(:set).with(name: :foo, value: ENV['bar'])

        expect { subject.run }.to raise_error KeyError
      end
    end
  end
end
