# Knowledge

Configuration variables are a project's knowledge. Knowledge is here to help your projects learn what they need to work properly.

Knowledge is a multi-source highly customizable configuration variables manager.


## Disclaimer

The library has been entirely rewritten; you can find the documentation for `0.x` versions in the [wiki](https://github.com/knowledge-ruby/knowledge/wiki)

## Knowledge official ecosystem

- [knowledge](https://github.com/knowledge-ruby/knowledge) - Core project
- [knowledge-rails](https://github.com/knowledge-ruby/knowledge-rails) - Rails utilities
- [knowledge-ssm](https://github.com/knowledge-ruby/knowledge-ssm) - SSM Adapter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'knowledge', '~> 1.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knowledge -v "~> 1.0"

## Usage

### Setup the configuration using a hash as a source

```ruby
Knowledge.learn_from :hash, variables: { key: :value }

Knowledge::Configuration.key # => "value"
```

or

```ruby
Knowledge.environment = :production

Knowledge.learn_from :hash, variables: {
  staging: {
    key: 'staging-value'
  },
  production: {
    key: 'production-value'
  }
}

Knowledge::Configuration.key # => "production-value"
```

### Setup the configuration using a config file as a source

path/to/file.yml:

```yml
key: value
```

```ruby
Knowledge.learn_from :yaml, variables: 'path/to/file.yml'

Knowledge::Configuration.key # => "value"
```

Or

path/to/file.yml:

```yml
staging:
    key: staging-value
production:
    key: production-value
```

```ruby
Knowledge.environment = :production

Knowledge.learn_from :yaml, variables: 'path/to/file.yml'

Knowledge::Configuration.key # => "production-value"
```

### Setup the configuration using environment variables as a source

```ruby
# ENV['AWS_REGION'] 'us-west-1'
Knowledge.learn_from :env, variables: { AWS_REGION: :default_region }

Knowledge::Configuration.default_region # => "us-west-1"
```

### Export your whole configuration in a Hash

```ruby
Knowledge.learn_from :hash, variables: { key: :value }

Knowledge::Configuration.key # => "value"

Knowledge.export_in :hash
# => { key: :value }
```

### Export your whole configuration in Json

```ruby
Knowledge.learn_from :json, variables: { key: :value }

Knowledge::Configuration.key # => "value"

Knowledge.export_in :json
# => "{\"key\":\"value\"}"

Knowledge.export_in :json, destination: '/path/to/exported/config.json'
# cat /path/to/exported/config.json
# => {"key":"value"}
```

### Export your whole configuration in Yaml

```ruby
Knowledge.learn_from :yaml, variables: { key: :value }

Knowledge::Configuration.key # => "value"

Knowledge.export_in :yaml
# => "key: value"

Knowledge.export_in :yaml, destination: '/path/to/exported/config.yml'
# cat /path/to/exported/config.yml
# => key: value
```


### Fetch and export your configuration in a Hash

```ruby
Knowledge.export_learnings_from(:hash, variables: { key: :value }).in(:hash)
# => { key: :value }
```

### Fetch and export your configuration in Json

```ruby
Knowledge.export_learnings_from(:json, variables: { key: :value }).in(:json)
# => "{\"key\":\"value\"}"

Knowledge.export_learnings_from(:json, variables: { key: :value }).in(:json, destination: '/path/to/exported/config.json')
# cat /path/to/exported/config.json
# => {"key":"value"}
```

### Fetch and export your configuration in Yaml

```ruby
Knowledge.export_learnings_from(:yaml, variables: { key: :value }).in(:yaml)
# => "key: value"

Knowledge.export_learnings_from(:yaml, variables: { key: :value }).in(:yaml, destination: '/path/to/exported/config.yml')
# cat /path/to/exported/config.yml
# => key: value
```

## Customisation

### Create your own getter to fetch variables from an unsupported source

Getters are initialized with the content passed to the `variables:` keyword argument of `Knowledge#learn_from`.

Getters must define a `#call` method that is supposed to return variables.

Getters are resolved by their names within the `Knowledge::Getters` namespace. Just give an underscored version of the getter name to `#learn_from` method.

```ruby
module Knowledge
  module Getters
    class RemoteUrl
      def initialize(url)
        @url = url # Set whatever variables you need
      end

      def call
        JSON.parse(HTTParty.get(@url).body) # Return variables
      end
    end
  end
end

url = 'https://api.mycompany.com/config/project-5.json'

Knowledge.learn_from :remote_url, variables: url

Knowledge::Configuration.key # => "value"
```

### Create your own setter to set variables on a different object

Setters must define a `#call` method that is in charge of actually setting the variables where they're supposed to be set.

You can access to `@data` which is a key: value hash from the `#call` method.

```ruby
module Knowledge
  module Setters
    class Rails < Base
      def call
        @data.each do |key, value|
          set(name: key, value: value)
        end
      end

      def set(name:, value:)
        Rails.application.config.public_send("#{name}=", value)
      end
    end
  end
end

Knowledge.learn_from :hash,
                     variables: { key: :value },
                     setter: :rails

Rails.application.config.key # => "value"
```

## Development

### Without docker

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### With docker

First, please ensure you've got docker and docker-compose properly setup on your computer

Then run:

```bash
$ docker-compose build
```

Once the build has been done, run:

```bash
$ docker-compose up
```

You will be able to see linting and test tasks running each time you change a file.

You will also find the yard doc under `http://localhost:5001` and the coverage under `http://localhost:5002`.

You can have a look at the `Makefile` if you want to use some extra utilities.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/knowledge-ruby/knowledge. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Knowledge project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/knowledge-ruby/knowledge/blob/master/CODE_OF_CONDUCT.md).

## Licensing

This project is licensed under [GPLv3+](https://www.gnu.org/licenses/gpl-3.0.en.html).

You can find it in LICENSE.md file.

Note: if you're a company willing to use the gem but you cannot because of the license, I can provide the gem under a different license. Please contact me if you need it.
