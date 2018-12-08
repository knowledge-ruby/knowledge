# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Backupper do
  let(:path) { 'path/to/file.yml' }

  subject { described_class.new(path: path) }

  describe '#initialize' do
    it { expect(subject.configuration).to be_a Hash }
    it { expect(subject.path).to eq path }
  end

  describe '#backup!' do
    let(:config) { { foo: :bar } }
    let(:expected_yaml) { config.to_yaml }
    let(:file_mock) { double }

    it 'backups config in the given file' do
      expect(File).to receive(:new).with(path, 'w').and_return(file_mock)
      expect(file_mock).to receive(:write).with(expected_yaml)
      expect(file_mock).to receive(:close)

      subject.instance_variable_set(:@configuration, config)

      subject.backup!
    end
  end

  describe '#set / #register' do
    it 'sets the variable on the configuration' do
      subject.set(name: :foo, value: :bar)
      subject.register(name: :bar, value: :baz)

      expect(subject.configuration[:foo]).to eq :bar
      expect(subject.configuration[:bar]).to eq :baz
    end
  end
end
