# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Setter do
  describe '#initialize' do
    it { expect(subject.instance_variable_get(:@configuration)).to be ::Knowledge::Configuration }
  end

  describe '#set' do
    it 'sets the variable on the configuration' do
      subject.set(name: :foo, value: :bar)

      expect(::Knowledge::Configuration.foo).to eq :bar
    end
  end
end
