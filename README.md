# Healthchecker

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'healthchecker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install healthchecker

## Usage

In your `config/routes.rb`, mount the engine:
```ruby
Rails.application.routes.draw do
  # ...
  mount Healthchecker::Engine => '/healthchecker'

  # Any wild card end-points
end
```

In an initializer such as `config/initializers/healthchecker.rb`, add your checks.
Example:
```ruby
class CustomHealthcheck < Healthchecker::BaseCheck
  def check!
    options[:pass_value] == 'FOO'
  end
end

Healthchecker.add_check(:redis, client: Resque.redis, description: 'Resque.redis')
Healthchecker.add_check(:redis, client: Redis.current, description: 'Some description that will show up in error messages')
Healthchecker.add_check(:database)
Healthchecker.add_check(:migration)
Healthchecker.add_check(:cache)
Healthchecker.add_check(:s3, client: Aws::S3::Client.new(my: :config), buckets: ['my_bucket1', 'my_bucket2'])
Healthchecker.add_check(HttpGetHealthcheck, pass_value: 'FOO')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Tout/healthchecker.
