# frozen_string_literal: true

RSpec.describe Knowledge::Exporters::Base do
  subject(:exporter) { described_class.new(data: data, destination: destination) }

  let(:data) { {} }
  let(:destination) { '/dev/null' }

  describe '#initialize' do
    it 'sets @data' do
      expect(exporter.instance_variable_get(:@data)).to eq data
    end

    it 'sets @destination' do
      expect(exporter.instance_variable_get(:@destination)).to eq destination
    end
  end

  describe '#call' do
    it 'raises Knowledge::NotImplemented' do
      expect { exporter.call }.to raise_error Knowledge::NotImplemented
    end
  end
end
