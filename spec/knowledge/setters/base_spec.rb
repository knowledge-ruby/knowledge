# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Knowledge::Setters::Base do
  describe '#set' do
    it 'raises a Knowledge::SetterSetMethodNotImplemented' do
      expect { subject.set(name: :foo, value: :bar) }.to raise_error(::Knowledge::SetterSetMethodNotImplemented)
    end
  end
end
