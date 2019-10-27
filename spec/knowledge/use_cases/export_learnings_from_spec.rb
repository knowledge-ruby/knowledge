# frozen_string_literal: true

RSpec.describe Knowledge::UseCases::ExportLearningsFrom do
  subject(:exporter_returned) { Knowledge.export_learnings_from :json, variables: path }

  let(:json_data) { '{"foo":"bar"}' }
  let(:path) { '/path/to/config.json' }
  let(:destination) { '/path/to/export.json' }
  let(:expected_data) { { foo: 'bar' } }

  before do
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with(path).and_return(json_data)

    Knowledge.learn_from(:json, variables: path)
  end

  it 'returns an exporter' do
    expect(exporter_returned).to be_a Knowledge::Core::Exporter
  end

  it 'sets data on exporter' do
    expect(exporter_returned.instance_variable_get(:@data)).to eq expected_data
  end

  describe '#in' do
    subject(:exported_data) { exporter_returned.in(:json, destination: destination) }

    context 'without a destination' do
      let(:destination) { nil }
      let(:expected_data) { { foo: 'bar' } }

      it 'returns the data' do
        expect(exported_data).to eq expected_data.to_json
      end
    end

    context 'with a destination' do
      let(:expected_data) { { foo: 'bar' } }

      before { allow(File).to receive(:write) }

      it 'returns the data and writes the file' do
        expect(exported_data).to eq expected_data.to_json
        expect(File).to have_received(:write).with(destination, json_data)
      end
    end
  end
end
