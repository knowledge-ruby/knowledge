# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Adapters::Base do
  let(:variables) { { foo: :bar } }
  let(:setter) { :setter }

  subject { described_class.new(variables: variables, setter: setter) }

  describe '#initialize' do
    it 'sets the variables' do
      expect(subject.variables).to eq variables
      expect(subject.setter).to eq setter
    end
  end

  describe '#run' do
    it 'raises a Knowledge::AdapterRunMethodNotImplemented' do
      expect { subject.run }.to raise_error Knowledge::AdapterRunMethodNotImplemented
    end
  end
end
