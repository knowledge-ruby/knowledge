# frozen_string_literal: true

RSpec.describe Knowledge::UseCases::LearnFrom do
  let(:json_data) { '{"foo":"bar"}' }
  let(:path) { '/path/to/config.json' }

  before do
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with(path).and_return(json_data)

    Knowledge.learn_from(:json, variables: path)
  end

  it 'sets the config' do
    expect(Knowledge::Configuration.foo).to eq 'bar'
  end
end
