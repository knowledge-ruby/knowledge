# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knowledge/version'

Gem::Specification.new do |spec|
  spec.name          = 'knowledge'
  spec.version       = Knowledge::VERSION
  spec.authors       = ['Johann Wilfrid-Calixte']
  spec.email         = ['johann.open-source@protonmail.ch']

  spec.licenses      = ['GPL-3.0']

  spec.summary       = "Because configuration is your app's knowledge."
  spec.description   = 'Easy knowledge for yout project.'
  spec.homepage      = 'https://github.com/knowledge-ruby/knowledge'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://johann.wilfrid-calixte.fr'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/knowledge-ruby/knowledge'
    spec.metadata['changelog_uri'] = 'https://github.com/knowledge-ruby/knowledge/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '>= 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '>= 0.60'
  spec.add_development_dependency 'simplecov'
end
