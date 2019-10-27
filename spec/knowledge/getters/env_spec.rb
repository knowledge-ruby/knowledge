# frozen_string_literal: true

RSpec.describe Knowledge::Getters::Env do
  subject(:getter) { described_class.new(variables) }

  let(:variables) { { FOO_IN_ENV: :bar_in_config, UNEXISTING: :unexisting } }

  describe '#call' do
    let(:foo_in_env) { 'hello' }

    before { ENV['FOO_IN_ENV'] = foo_in_env }

    context 'when variable exists in env' do
      subject(:config) { getter.call }

      it 'gets it and renames it' do
        expect(config).to have_key :bar_in_config
        expect(config[:bar_in_config]).to eq foo_in_env
      end
    end

    context 'when variable does not exist in env' do
      subject(:config) { getter.call }

      it 'sets it to nil and renames it' do
        expect(config).to have_key :unexisting
        expect(config[:unexisting]).to be_nil
      end
    end
  end
end
