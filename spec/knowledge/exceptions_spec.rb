# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Exceptions' do
  describe 'Knowledge::Error' do
    it 'inherits from StandardError' do
      expect(::Knowledge::Error).to be < ::StandardError
    end
  end

  [
    Knowledge::AdapterNotFound, Knowledge::AdapterRunMethodNotImplemented,
    Knowledge::LearnError, Knowledge::RegisterError
  ].each do |lib_exception|
    describe lib_exception.to_s do
      it 'inherits from Knowledge::Error' do
        expect(lib_exception).to be < Knowledge::Error
      end
    end
  end
end
