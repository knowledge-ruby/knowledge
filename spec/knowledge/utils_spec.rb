# frozen_string_literal: true

RSpec.describe Knowledge::Utils do
  describe '#camelize' do
    subject(:camelize) { described_class.camelize(str) }

    let(:str) { nil }

    context 'with nil' do
      it 'does not raise' do
        expect { camelize }.not_to raise_error
      end
    end

    context 'with a single word' do
      let(:str) { :foo }

      it 'capitalizes' do
        expect(camelize).to eq 'Foo'
      end
    end

    context 'with underscore separated words' do
      let(:str) { :foo_bar }

      it 'camelizes it' do
        expect(camelize).to eq 'FooBar'
      end
    end

    context 'with dash separated words' do
      let(:str) { 'foo-bar' }

      it 'camelizes it' do
        expect(camelize).to eq 'FooBar'
      end
    end
  end

  describe '#resolve_class' do
    subject(:resolve) { described_class.resolve_class(namespace: namespace, class_name: class_name, exception: error) }

    let(:namespace) { Knowledge::Getters }
    let(:class_name) { 'Base' }
    let(:error) do
      class TestEror < StandardError; end

      TestEror
    end

    context 'when class does not need to be resolved' do
      let(:class_name) { Class }

      it 'returns it as is' do
        expect(resolve).to eq class_name
      end
    end

    context 'when class is not found' do
      before { allow(namespace).to receive(:const_get).and_raise NameError }

      it 'raises given error' do
        expect { resolve }.to raise_error error, "Cannot find #{namespace}::#{class_name}"
      end
    end

    context 'when result is not a class' do
      before { allow(namespace).to receive(:const_get).and_return Module.new }

      it 'raises given error' do
        expect { resolve }.to raise_error error, "Cannot find #{namespace}::#{class_name}"
      end
    end

    context 'when class is successfully resolved' do
      it 'returns it' do
        expect(resolve).to eq Knowledge::Getters::Base
      end
    end
  end

  describe '#ensure_callable' do
    subject(:ensure_callable) { described_class.ensure_callable(object) }

    let(:callable) { true }
    let(:object) { instance_double('object') }

    before { allow(object).to receive(:respond_to?).with(:call).and_return(callable) }

    context 'when object responds to #call' do
      it 'returns the object' do
        expect(ensure_callable).to eq object
      end
    end

    context 'when object does not respond to #call' do
      let(:callable) { false }

      it 'raises Knowledge::NotCallable' do
        expect { ensure_callable }.to raise_error Knowledge::NotCallable
      end
    end
  end

  describe '#raise_not_callable_parent_method' do
    subject(:raise_not_callable_parent_method) do
      described_class.raise_not_callable_parent_method(parent_class: parent_class)
    end

    let(:parent_class) { 'Toto' }

    it 'raises Knowledge::NotImplemented' do
      expect { raise_not_callable_parent_method }.to raise_error Knowledge::NotImplemented
    end
  end
end
