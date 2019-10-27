# frozen_string_literal: true

RSpec.describe Knowledge::Setters::Default do
  it 'inherits from Knowledge setter' do
    expect(described_class).to be < Knowledge::Setters::Knowledge
  end
end
