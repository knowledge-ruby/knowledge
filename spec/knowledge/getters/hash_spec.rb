# frozen_string_literal: true

RSpec.describe Knowledge::Getters::Hash do
  subject(:getter) { described_class.new(variables) }

  let(:variables) { { key: :value } }

  describe '#call' do
    subject(:config) { getter.call }

    it 'gets it' do
      expect(config).to eq variables
    end
  end
end
