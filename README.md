# Dry::System::Hanami
Some magic stuff for autoload folders to dry-system in hanami projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry-system-hanami'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dry-system-hanami

## Usage

```ruby
require 'dry/system/container'
require 'dry/system/hanami'

class Container < Dry::System::Container
  extend Dry::System::Hanami::Resolver

  #  Core
  register_folder! 'project_name/repositories'
  register_folder! 'project_name/core'
  register_folder! 'project_name/services'

  # Tasks domain
  register_folder! 'tasks/interactors', resolver: ->(k) { k }
  register_folder! 'tasks/matchers', resolver: ->(k) { k::Matcher }

  configure
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dry::System::Hanami project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/davydovanton/dry-system-hanami/blob/master/CODE_OF_CONDUCT.md).
