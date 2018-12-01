# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Learner do
  describe '#initialize' do
    it 'sets base variables' do
      expect(subject.additionnal_params).not_to be_nil
      expect(subject.available_adapters).not_to be_nil
      expect(subject.enabled_adapters).not_to be_nil
      expect(subject.setter).to be_a Knowledge::Setter
      expect(subject.variables).not_to be_nil
    end
  end

  describe '#gather!' do
    let(:mocked_initializer) { instance_double('initializer') }

    it 'relies on the initializer' do
      expect(mocked_initializer).to receive(:run)

      expect(Knowledge::Initializer).to receive(:new).with(
        adapters: {},
        params: {},
        setter: kind_of(Knowledge::Setter),
        variables: {}
      ).and_return(mocked_initializer)

      subject.gather!
    end
  end

  describe '#add_adapter_param' do
    let(:adapter_name) { :test_adapter }
    let(:name) { :new_param }
    let(:value) { :new_param_value }

    it 'adds the parameter' do
      subject.add_adapter_param(adapter: adapter_name, name: name, value: value)

      expect(subject.additionnal_params).to have_key adapter_name
      expect(subject.additionnal_params[adapter_name]).to have_key name
      expect(subject.additionnal_params[adapter_name][name]).to eq value
    end
  end

  describe '#add_adapter_params' do
    let(:adapter_name) { :test_adapter }
    let(:params) { { foo: :bar } }

    it 'adds the parameters' do
      subject.add_adapter_params(adapter: adapter_name, params: params)

      expect(subject.additionnal_params).to have_key adapter_name
      expect(subject.additionnal_params[adapter_name]).to eq params
    end
  end

  describe '#disable_adapter' do
    let(:fake_adapter) { double }

    before { subject.enabled_adapters[:fake_adapter] = fake_adapter }

    it 'removes the adapter from enabled list' do
      subject.disable_adapter(name: :fake_adapter)

      expect(subject.enabled_adapters).not_to have_key :fake_adapter
    end
  end

  describe '#enable_adapter' do
    context 'available adapter' do
      let(:adapter) { double }
      let(:name) { :known_adapter }

      before { subject.available_adapters[name] = adapter }

      it 'puts the adapter un enabled adapters' do
        subject.enable_adapter(name: name)

        expect(subject.enabled_adapters[name]).to eq adapter
      end

      context 'with variables' do
        let(:variables) { { foo: :bar } }

        it 'sets the variables' do
          subject.enable_adapter(name: name, variables: variables)

          expect(subject.variables[name]).to eq variables
        end
      end
    end

    context 'unknown adapter' do
      it 'raises an Knowledge::AdapterNotFound' do
        expect { subject.enable_adapter(name: :unknown) }.to raise_error Knowledge::AdapterNotFound
      end
    end
  end

  describe '#register_adapter' do
    let(:name) { :test_adapter }
    let(:klass) { double }

    context 'without asking to enable' do
      it 'registers the adapter' do
        expect(subject).not_to receive(:enable_adapter)

        subject.register_adapter(name: name, klass: klass)

        expect(subject.available_adapters).to have_key name
        expect(subject.available_adapters[name]).to eq klass
      end
    end

    context 'asking to enable' do
      it 'enables the adapter after registering it' do
        expect(subject).to receive(:enable_adapter).with(name: name)

        subject.register_adapter(name: name, klass: klass, enable: true)
      end
    end

    context 'with variables' do
      let(:variables) { { foo: :bar } }

      it 'sets the variables' do
        subject.register_adapter(name: name, klass: klass, variables: variables)

        expect(subject.variables[name]).to eq variables
      end
    end
  end

  describe '#set_adapter_variables' do
    context 'passed variables is a Hash' do
      let(:name) { :adapter }
      let(:variables) { { foo: :bar } }

      it 'relies on #set_adapter_variables_by_hash' do
        expect(subject).to receive(:set_adapter_variables_by_hash).with(name: name, variables: variables)

        subject.set_adapter_variables(name: name, variables: variables)
      end
    end

    context 'passed variables is a String' do
      let(:path) { 'path/to.yml' }
      let(:yaml_content) { { 'foo' => 'bar' } }

      it 'relies on #yaml_content to get a hash and calls itself' do
        expected_params = { name: :adapter, variables: yaml_content }

        expect(subject).to receive(:yaml_content).and_return(yaml_content)
        allow(subject).to receive(:set_adapter_variables).and_call_original.once
        expect(subject).to receive(:set_adapter_variables).with(**expected_params).and_call_original

        subject.set_adapter_variables(name: :adapter, variables: path)

        expect(subject.variables).to have_key :adapter
        expect(subject.variables[:adapter]).to eq yaml_content
      end
    end

    context 'passed variables is not a Hash nor a String nor a falsey' do
      it 'raises a Knowledge::LearnError' do
        expect { subject.set_adapter_variables(name: :anything, variables: []) }.to raise_error Knowledge::LearnError
      end
    end
  end

  describe '#set_adapter_variables_by_hash' do
    context 'scoped on the adapter' do
      context 'string keys' do
        let(:variables) { { 'adapter' => { 'foo' => 'bar' } } }

        it 'sets variables as expected' do
          subject.set_adapter_variables_by_hash(name: :adapter, variables: variables)

          expect(subject.variables).to have_key :adapter
          expect(subject.variables[:adapter]).to eq variables['adapter']
        end
      end

      context 'symbol keys' do
        let(:variables) { { adapter: { foo: 'bar' } } }

        it 'sets variables as expected' do
          subject.set_adapter_variables_by_hash(name: :adapter, variables: variables)

          expect(subject.variables).to have_key :adapter
          expect(subject.variables[:adapter]).to eq variables[:adapter]
        end
      end
    end

    context 'not scoped on the adapter' do
      let(:variables) { { foo: 'bar' } }

      it 'sets variables as expected' do
        subject.set_adapter_variables_by_hash(name: :adapter, variables: variables)

        expect(subject.variables).to have_key :adapter
        expect(subject.variables[:adapter]).to eq variables
      end
    end
  end

  describe '#unregister_adapter' do
    let(:name) { :test_adapter }
    let(:klass) { double }

    before { subject.register_adapter(name: name, klass: klass) }

    it 'removes the adapter from available ones' do
      subject.unregister_adapter(name: name)

      expect(subject.available_adapters).not_to have_key name
    end
  end

  describe '#use' do
    context 'unknown adapter' do
      it 'raises a Knowledge::RegisterError' do
        expect { subject.use(name: :unknown) }.to raise_error Knowledge::RegisterError
      end
    end

    context 'given name is default, keyval or key_value' do
      %i[default keyval key_value].each do |name|
        it 'registers and enables the Knowledge::Adapters::KeyValue adapter' do
          subject.use(name: name)

          expect(subject.available_adapters).to have_key :default
          expect(subject.enabled_adapters).to have_key :default
          expect(subject.available_adapters[:default]).to eq Knowledge::Adapters::KeyValue
          expect(subject.enabled_adapters[:default]).to eq Knowledge::Adapters::KeyValue
        end
      end
    end

    context 'given name is env, environment or env_vars' do
      %i[env environment env_vars].each do |name|
        it 'registers and enables the Knowledge::Adapters::Environment adapter' do
          subject.use(name: name)

          expect(subject.available_adapters).to have_key :environment
          expect(subject.enabled_adapters).to have_key :environment
          expect(subject.available_adapters[:environment]).to eq Knowledge::Adapters::Environment
          expect(subject.enabled_adapters[:environment]).to eq Knowledge::Adapters::Environment
        end
      end
    end

    context 'given name is config, file or config_file' do
      %i[config file config_file].each do |name|
        it 'registers and enables the Knowledge::Adapters::File adapter' do
          subject.use(name: name)

          expect(subject.available_adapters).to have_key :file
          expect(subject.enabled_adapters).to have_key :file
          expect(subject.available_adapters[:file]).to eq Knowledge::Adapters::File
          expect(subject.enabled_adapters[:file]).to eq Knowledge::Adapters::File
        end
      end
    end

    context 'ask not to enable' do
      it 'registers only' do
        expect(subject).not_to receive(:enable_adapter)

        subject.use(name: :default, enable: false)

        expect(subject.available_adapters).to have_key :default
        expect(subject.enabled_adapters).not_to have_key :default
        expect(subject.available_adapters[:default]).to eq Knowledge::Adapters::KeyValue
        expect(subject.enabled_adapters[:default]).to be_nil
      end
    end
  end

  describe '#variables=' do
    context 'given param is a Hash' do
      let(:variables) { { foo: :bar } }

      it 'sets the variables' do
        subject.variables = variables

        expect(subject.variables).to eq variables
      end
    end

    context 'given param is a String' do
      let(:variables) { 'path/to/config/file.yml' }

      it 'relies on #fetch_variables_config' do
        expect(subject).to receive(:fetch_variables_config).with(variables)

        subject.variables = variables
      end
    end

    context 'given param is not a Hash nor a String' do
      it 'raises a Knowledge::LearnError' do
        expect { subject.variables = false }.to raise_error Knowledge::LearnError
      end
    end
  end

  describe '#fetch_variables_config' do
    let(:path) { 'path/to/config/file.yml' }

    context 'config file without environment at root' do
      it 'sets variables with config file content' do
        expect(subject).to receive(:yaml_content).and_return('foo' => 'bar')

        subject.send(:fetch_variables_config, path)

        expect(subject.variables).to eq('foo' => 'bar')
      end
    end

    context 'config file with environment at root' do
      it 'sets variables with config file content according to the right env' do
        expect(subject).to receive(:yaml_content).and_return(
          'development' => { 'foo' => 'bar' },
          'production' => { 'bar' => 'baz' }
        )

        subject.send(:fetch_variables_config, path)

        expect(subject.variables).to eq('foo' => 'bar')
      end
    end
  end

  describe '#yaml_content' do
    let(:path) { 'path/to.yml' }
    let(:yaml_config) { 'foo: bar' }

    before do
      expect(File).to receive(:open).with(path).and_return(yaml_config)
    end

    it 'just open file and convert to hash' do
      expect(subject.send(:yaml_content, path)).to eq('foo' => 'bar')
    end
  end
end
