# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Initializer do
  describe '#initialize' do
    it 'sets instance variables' do
      instance = described_class.new(adapters: :adapters, params: :params, setter: :setter, variables: :variables)

      %w[adapters params setter variables].each do |var|
        expect(instance.instance_variable_get(:"@#{var}")).to eq var.to_sym
      end
    end
  end

  describe '#run' do
    context 'no adapters' do
      it 'does not raise any error' do
        initializer = described_class.new(adapters: nil, params: [], setter: nil, variables: [])

        initializer.run
      end
    end

    context 'with adapters' do

      let(:adapter) { double('adapter') }
      let(:instance_adapter) { instance_double('adapter') }
      let(:params) { {} }
      let(:setter) { :setter }
      let(:variables) { {} }

      subject do
        described_class.new(adapters: { adapter: adapter }, params: params, setter: setter, variables: variables)
      end

      it 'instanciates and runs it' do
        expect(instance_adapter).to receive(:run)

        expect(adapter).to receive(:new).with(
          params: params,
          setter: setter,
          variables: variables
        ).and_return(instance_adapter)

        subject.run
      end
    end
  end

  describe '#run class method' do
    let(:adapter) { double('adapter') }
    let(:instance_adapter) { instance_double('adapter') }
    let(:params) { {} }
    let(:setter) { :setter }
    let(:variables) { {} }

    it 'instanciates adapter and runs it' do
      expect(instance_adapter).to receive(:run)

      expect(adapter).to receive(:new).with(
        params: params,
        setter: setter,
        variables: variables
      ).and_return(instance_adapter)

      described_class.run(adapters: { adapter: adapter }, params: params, setter: setter, variables: variables)
    end
  end
end
