# frozen_string_literal: true

RSpec.describe Knowledge::Exporters::Json do
  subject(:exporter) { described_class.new(data: data, destination: destination) }

  let(:data) { { foo: :bar } }
  let(:json_data) { '{"foo":"bar"}' }
  let(:destination) { '/dev/null' }

  describe '#call' do
    before { allow(File).to receive(:write) }

    it 'converts hash to json' do
      expect(exporter.call).to eq json_data
    end

    context 'with a destination' do
      before { exporter.call }

      it 'creates a file' do
        expect(File).to have_received(:write).with(destination, json_data)
      end
    end

    context 'without a destination' do
      let(:destination) { nil }

      before { exporter.call }

      it 'does not create a file' do
        expect(File).not_to have_received(:write)
      end
    end
  end
end
