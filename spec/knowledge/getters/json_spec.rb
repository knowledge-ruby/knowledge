# frozen_string_literal: true

RSpec.describe Knowledge::Getters::Json do
  subject(:getter) { described_class.new(path) }

  let(:path) { '/path/to/config.json' }

  describe '#call' do
    subject(:config) { getter.call }

    let(:json_file_content) { '{"key":"value"}' }
    let(:data) { { key: 'value' } }

    before do
      expect(File).to receive(:read).and_return json_file_content
    end

    context 'without environment' do
      it 'gets data from file' do
        expect(config).to eq data
      end
    end

    context 'with environment' do
      let(:environment) { :test }
      let(:json_file_content) { '{"test":{"key":"value"}}' }

      before { Knowledge.environment = environment }

      it 'gets data from the right env' do
        expect(config).to eq data
      end
    end
  end
end
