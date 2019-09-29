# Knowledge

Configuration variables are a project's knowledge. This gem is here to help your projects learn what they need to work properly.

Knowledge is a multi-source highly customizable configuration variables manager.


## Disclaimer

The full documentation is currently being written. You should be able to find a better documentation in a few hours / days.

Waiting for the full documentation, you can have a look at the code which is already well-documented or at the [wiki](https://github.com/knowledge-ruby/knowledge/wiki)

## Knowledge official ecosystem

- [knowledge](https://github.com/knowledge-ruby/knowledge) - Core project
- [knowledge-rails](https://github.com/knowledge-ruby/knowledge-rails) - Rails utilities
- [knowledge-ssm](https://github.com/knowledge-ruby/knowledge-ssm) - SSM Adapter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'knowledge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knowledge

## Usage

Documentation is in progress. Please have a look to the [wiki](https://github.com/knowledge-ruby/knowledge/wiki/).

**Using default stuff**:

```ruby
knowledge = Knowledge::Learner.new

knowledge.use(name: :default)
knowledge.variables = { key: :value }
knowledge.gather!

Knowledge::Configuration.key # => "value"
```

**Using a config file**:

```yml
key: value
```

```ruby
knowledge = Knowledge::Learner.new

knowledge.use(name: :file)
knowledge.variables = 'path/to/file.yml'
knowledge.gather!

Knowledge::Configuration.key # => "value"
```

Or

```yml
development:
    key: value
production:
    key: other_value
```

```ruby
Knowledge.config.environment = :production

knowledge = Knowledge::Learner.new

knowledge.use(name: :file)
knowledge.variables = 'path/to/file.yml'
knowledge.gather!

Knowledge::Configuration.key # => "other_value"
```

**Using your own setter**:

```ruby
#
# === Description ===
#
# Sets config variables in Rails.application.config
#
# === Usage ===
#
# @example:
#   setter = MyCustomRailsSetter.new
#   setter.set(name: :foo, value: :bar)
#
#   Rails.application.config.foo # => "bar"
#
class MyCustomRailsSetter
    #
    # === Description ===
    #
    # Sets config variables in the right place.
    #
    # === Usage ===
    #
    # See the same section in the class description.
    #
    # === Attributes ===
    #
    # @option [String | Symbol] :name
    # @option [Any] :value
    #
    def set(name:, value:)
        Rails.application.config.public_send("#{name}=", value)
    end
end

knowledge = Knowledge::Learner.new

knowledge.setter = MyCustomRailsSetter.new
knowledge.use(name: :default)
knowledge.variables = { key: :value }
knowledge.gather!

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
