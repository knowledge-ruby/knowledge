# frozen_string_literal: true

RSpec.describe Knowledge::Setters::Exporter do
  subject(:setter) { described_class.new(data: data) }

  let(:data) { { vari: :ables } }

  describe '#call' do
    it 'returns it as is' do
      expect(setter.call).to eq data
    end
  end
end
