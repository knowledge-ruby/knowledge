# frozen_string_literal: true

RSpec.describe Knowledge::Getters::File do
  subject(:getter) { described_class.new(path) }

  let(:path) { '/dev/null' }

  describe '#initialize' do
    it 'sets @path' do
      expect(getter.instance_variable_get(:@path)).to eq path
    end
  end

  describe '#call' do
    it 'raises Knowledge::NotImplemented' do
      expect { getter.call }.to raise_error Knowledge::NotImplemented
    end
  end
end
