# frozen_string_literal: true

group :doc do
  guard 'process', command: 'bundle exec yardoc && yard server -B 0.0.0.0 -p 5001 --reload' do
    watch(%r{^(?!spec/).*\.rb$})
  end
end

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
