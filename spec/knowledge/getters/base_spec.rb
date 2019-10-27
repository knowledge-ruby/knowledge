# frozen_string_literal: true

RSpec.describe Knowledge::Getters::Base do
  subject(:getter) { described_class.new(variables) }

  let(:variables) { { vari: :ables } }

  describe '#initialize' do
    context 'when no Knowledge.environment not set' do
      it 'sets @variables as is' do
        expect(subject.instance_variable_get(:@variables)).to eq variables
      end
    end

    context 'when Knowledge.environment is not a root key of variables' do
      before { Knowledge.environment = :test }

      it 'sets @variables as is' do
        expect(subject.instance_variable_get(:@variables)).to eq variables
      end
    end

    context 'when Knowledge.environment is a root key of variables' do
      let(:variables) { { test: { vari: :ables } } }
      let(:environment) { :test }

      context 'when Knowledge.environment is a symbol' do
        before { Knowledge.environment = environment }

        it 'sets @variables as is' do
          expect(subject.instance_variable_get(:@variables)).to eq variables[:test]
        end
      end

      context 'when Knowledge.environment is a string' do
        let(:environment) { 'test' }

        before { Knowledge.environment = environment }

        it 'sets @variables as is' do
          expect(subject.instance_variable_get(:@variables)).to eq variables[:test]
        end
      end
    end
  end

  describe '#call' do
    it 'raises Knowledge::NotImplemented' do
      expect { getter.call }.to raise_error Knowledge::NotImplemented
    end
  end
end
