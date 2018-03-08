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

With that you will be able to hit:

curl <service_uri>/healthchecker/status
which will return 200 with {"status": "ok"}
or return 500 with {"status": <error messages>}

In an initializer such as `config/initializers/healthchecker.rb`, add your checks.
Example:
```ruby
class CustomHealthcheck < Healthchecker::Check
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
Healthchecker.add_check(CustomHealthcheck, pass_value: 'FOO')
```

### Supported Checks:
* redis
  * options: client, redis client - defaults to `Redis.new`
* database
* migration
* cache
  * options: cache_key, optional - the key to use when checking the cache, defaults to SecureRandom.hex (expires_in 1.second)
* s3
  * options: client, optional - defaults to `Aws::S3::Client.new`
  * options: buckets, required - list of bucket names to check
  * options: object_key, options - object_key to use when testing read, write, and delete privileges for each bucket. Defaults to `healthchecker/#{Time.now.to_i}.json`
* solr
  * options: rsolr_client, optional - defaults to default configuration sunspot uses
* dynamodb
  * options: client, optional - defaults to `Aws::DynamoDB::Client.new`

Note: All checks will return all passed options with failures with the addition of the check specified, by default

### Metrics:

curl <service_uri>/healthchecker/metrics
which will return a JSON response with selected metrics

In an initializer such as `config/initializers/healthchecker.rb`, add a configuration block.
You can add this block anywhere in the file, though it make most sense before the checks.

```ruby
Healthchecker.configure do |config|
  config.metrics = [:redis, :sidekiq]
end

# Healthchecker.add_check...
# Healthchecker.add_check...
```

* `config.metrics` - Determines which metrics to display in `metrics` endpoint
  * Defaults to `[:redis, :resque]`
  * Supported metrics are `:redis`, `:resque`, and `:sidekiq`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO:
1. Catch unexpected errors and return them along with the check that produced them
2. Include the check names with the error message along with options

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Tout/healthchecker.
