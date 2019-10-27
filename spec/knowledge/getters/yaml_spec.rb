# frozen_string_literal: true

RSpec.describe Knowledge::Getters::Yaml do
  subject(:getter) { described_class.new(path) }

  let(:path) { '/path/to/config.yml' }

  describe '#call' do
    subject(:config) { getter.call }

    let(:yaml_file_content) { "---\n:key: :value\n" }
    let(:data) { { key: :value } }

    before do
      expect(File).to receive(:open).and_yield yaml_file_content
    end

    context 'without environment' do
      it 'gets data from file' do
        expect(config).to eq data
      end
    end

    context 'with environment' do
      let(:environment) { :test }
      let(:yaml_file_content) { "---\n:test:\n  :key: :value\n" }

      before { Knowledge.environment = environment }

      it 'gets data from the right env' do
        expect(config).to eq data
      end
    end
  end
end
