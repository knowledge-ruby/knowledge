# frozen_string_literal: true

RSpec.describe Knowledge::Core::Exporter do
  subject(:exporter) { described_class.new(type: type, destination: destination, data: data) }

  let(:type) { :json_file }
  let(:destination) { '/dev/null' }
  let(:data) { {} }

  before do
    allow(exporter).to receive(:exporter_class).and_call_original
  end

  describe '#initialize' do
    it 'camelizes type' do
      expect(exporter.instance_variable_get(:@type)).to eq 'JsonFile'
    end

    it 'sets destination' do
      expect(exporter.instance_variable_get(:@destination)).to eq destination
    end

    it 'sets data' do
      expect(exporter.instance_variable_get(:@data)).to eq data
    end
  end

  describe '#call' do
    let(:exporter_class) { double('exporter_class', new: exporter_instance) }
    let(:exporter_instance) { instance_double('exporter_instance', call: nil) }
    let(:callable) { true }

    before do
      allow(exporter_class).to receive(:is_a?).with(Class).and_return(true)
      allow(exporter_instance).to receive(:respond_to?).with(:call).and_return(callable)
    end

    context 'when exporter is resolved and callable' do
      before do
        allow(Knowledge::Exporters).to receive(:const_get).and_return(exporter_class)
        exporter.call
      end

      it 'instanciates the exporter passing data & destination' do
        expect(exporter_class).to have_received(:new).with(destination: destination, data: data)
      end

      it 'calls the exporter' do
        expect(exporter_instance).to have_received(:call)
      end
    end

    context 'when exporter class cannot be resolved' do
      before { allow(Knowledge::Exporters).to receive(:const_get).and_raise(NameError) }

      it 'raises Knowledge::UnknownExporter' do
        expect { exporter.call }.to raise_error(Knowledge::UnknownExporter)
      end
    end

    context 'when resolved exporter is not a class' do
      before { allow(Knowledge::Exporters).to receive(:const_get).and_return(Module.new) }

      it 'raises Knowledge::UnknownExporter' do
        expect { exporter.call }.to raise_error(Knowledge::UnknownExporter)
      end
    end

    context 'when resolved exporter does not implement #call' do
      let(:callable) { false }

      before { allow(Knowledge::Exporters).to receive(:const_get).and_return(exporter_class) }

      it 'raises Knowledge::NotCallable' do
        expect { exporter.call }.to raise_error(Knowledge::NotCallable)
      end
    end
  end
end
