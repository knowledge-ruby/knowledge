# frozen_string_literal: true

group :linter do
  guard 'process', command: 'bundle exec rubocop -a' do
    watch(/\.rb$/)
  end
end

group :test do
  guard 'rspec', cmd: 'bundle exec rspec' do
    watch(/\.rb$/) { 'spec' }
  end
end
