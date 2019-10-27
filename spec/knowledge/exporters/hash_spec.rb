# frozen_string_literal: true

RSpec.describe Knowledge::Exporters::Hash do
  subject(:exporter) { described_class.new(data: data, destination: destination) }

  let(:data) { { foo: :bar } }
  let(:destination) { '/dev/null' }

  describe '#call' do
    it 'returns the hash' do
      expect(exporter.call).to eq data
    end
  end
end
