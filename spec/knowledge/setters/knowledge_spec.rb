# frozen_string_literal: true

RSpec.describe Knowledge::Setters::Knowledge do
  subject(:setter) { described_class.new(data: data) }

  let(:data) { { foo: :bar, baz: 'hello' } }

  describe '#call' do
    before { setter.call }

    it 'sets the variables on Knowledge::Configuration' do
      expect(Knowledge::Configuration.foo).to eq :bar
      expect(Knowledge::Configuration.baz).to eq 'hello'
    end
  end
end
