# frozen_string_literal: true

RSpec.describe Knowledge::Behaviors::Configurable do
  shared_examples 'configurable' do
    let(:setting_name) { :foo }
    let(:default_value) { :bar }

    before { configuration.setting setting_name, default: default_value }

    describe '#setting' do
      let(:new_value) { :baz }

      it 'creates the reader' do
        expect { configuration.public_send(setting_name) }.not_to raise_error
      end

      it 'sets the default value' do
        expect(configuration.public_send(setting_name)).to eq default_value
      end

      it 'creates the writer' do
        expect { configuration.public_send(:"#{setting_name}=", new_value) }.not_to raise_error
        expect(configuration.public_send(setting_name)).to eq new_value
      end
    end

    describe '#configure' do
      let(:new_value) { :foo }

      before do
        configuration.configure do |config|
          config.public_send(:"#{setting_name}=", new_value)
        end
      end

      it 'exposes configuration and allows modification' do
        expect(configuration.public_send(setting_name)).to eq new_value
      end
    end

    describe '#reset' do
      before { configuration.setting :foo, default: :bar }

      it 'resets the config' do
        configuration.reset

        expect(configuration[:foo]).to be_nil
      end
    end

    describe '[]' do
      context 'with a string key' do
        it 'reads the value' do
          expect(configuration[setting_name.to_s]).to eq default_value
        end
      end

      context 'with a symbol key' do
        it 'reads the value' do
          expect(configuration[setting_name.to_sym]).to eq default_value
        end
      end
    end

    describe '[]=' do
      context 'with a string key' do
        let(:new_value) { :new }

        it 'writes the value' do
          configuration[setting_name.to_s] = new_value

          expect(configuration[setting_name.to_s]).to eq new_value
        end
      end

      context 'with a symbol key' do
        let(:new_value) { :value }

        it 'writes the value' do
          configuration[setting_name.to_sym] = new_value

          expect(configuration[setting_name.to_sym]).to eq new_value
        end
      end
    end
  end

  context 'with a module' do
    subject(:configuration) do
      module ConfigurationModuleTest
        include Knowledge::Behaviors::Configurable
      end
    end

    it_behaves_like 'configurable'
  end

  context 'with a class' do
    subject(:configuration) do
      class ConfigurationClassTest
        include Knowledge::Behaviors::Configurable
      end
    end

    it_behaves_like 'configurable'
  end
end
