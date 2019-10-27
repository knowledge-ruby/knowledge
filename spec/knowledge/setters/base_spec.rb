# frozen_string_literal: true

RSpec.describe Knowledge::Setters::Base do
  subject(:setter) { described_class.new(data: data) }

  let(:data) { { vari: :ables } }

  describe '#initialize' do
    it 'sets @data as is' do
      expect(subject.instance_variable_get(:@data)).to eq data
    end
  end

  describe '#call' do
    it 'raises Knowledge::NotImplemented' do
      expect { setter.call }.to raise_error Knowledge::NotImplemented
    end
  end
end
