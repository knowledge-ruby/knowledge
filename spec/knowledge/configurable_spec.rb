# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Configurable do
  subject(:configurable) do
    Module.new do
      extend ::Knowledge::Configurable
    end
  end

  let(:variable_name) { :foo }
  let(:variable_value) { :bar }

  describe '#setting' do
    context 'without a default value' do
      before { subject.setting :foo }

      it 'creates the variable' do
        expect { subject.foo }.not_to raise_error
      end

      it 'sets the value to nil' do
        expect(subject.foo).to be_nil
      end
    end

    context 'with a default value' do
      let(:variable_value) { :bar }

      before { subject.setting variable_name, default: variable_value }

      it 'sets the value to nil' do
        expect(subject.foo).to eq variable_value
      end
    end
  end

  describe '#configure' do
    let(:new_value) { :baz }

    before do
      subject.setting variable_name, default: variable_value

      subject.configure do |config|
        config.public_send("#{variable_name}=", new_value)
      end
    end

    it 'exposes the configuration allowing to change variable values' do
      expect(subject.public_send(variable_name)).to eq new_value
    end
  end

  describe 'setters' do
    before { subject.setting variable_name, default: variable_value }

    context 'with method accessor' do
      it 'returns the value' do
        expect(subject.public_send(variable_name)).to eq variable_value
      end
    end

    context 'with hash accessor' do
      context 'with string key' do
        it 'returns the value' do
          expect(subject[variable_name.to_s]).to eq variable_value
        end
      end

      context 'with symbol key' do
        it 'returns the value' do
          expect(subject[variable_name.to_sym]).to eq variable_value
        end
      end
    end
  end

  describe 'setters' do
    let(:new_value) { :baz }

    before { subject.setting variable_name, default: variable_value }

    context 'with method setter' do
      before { subject.public_send("#{variable_name}=", new_value) }

      it 'returns the value' do
        expect(subject[variable_name]).to eq new_value
      end
    end

    context 'with hash setter' do
      context 'with string key' do
        before { subject[variable_name.to_s] = new_value }

        it 'returns the value' do
          expect(subject[variable_name]).to eq new_value
        end
      end

      context 'with symbol key' do
        before { subject[variable_name.to_sym] = new_value }

        it 'returns the value' do
          expect(subject[variable_name]).to eq new_value
        end
      end
    end
  end
end
