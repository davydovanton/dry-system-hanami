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

### `register_folder!`
You can regitser full folder to your container:

```ruby
require 'dry/system/container'
require 'dry/system/hanami'

class Container < Dry::System::Container
  extend Dry::System::Hanami::Resolver

  register_folder! 'project_name/repositories'
  # or with custom resolver
  register_folder! 'project_name/matchers', resolver: ->(k) { k }

  configure
end
```

### `load_file!`
You can regitser specific file to your container:

```ruby
require 'dry/system/container'
require 'dry/system/hanami'

class Container < Dry::System::Container
  extend Dry::System::Hanami::Resolver

  load_file! 'project_name/repositories/users'
  # or with custom resolver
  load_file! 'project_name/matchers/git_host', resolver: ->(k) { k }

  configure
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dry::System::Hanami project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/davydovanton/dry-system-hanami/blob/master/CODE_OF_CONDUCT.md).
