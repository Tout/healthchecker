require "healthchecker/engine"
require 'healthchecker/base_check'
require 'healthchecker/redis_check'
require 'healthchecker/migration_check'
require 'healthchecker/database_check'
require 'healthchecker/cache_check'
require 'healthchecker/s3_check'
require 'healthchecker/solr_check'

module Healthchecker
  APPLICATION_STARTED_AT = Time.now

  mattr_accessor :checks
  self.checks = []

  def self.add_check(name_or_class, options={})
    self.checks << lookup_class(name_or_class).new(options.merge(check: name_or_class))
  end

  def self.perform_checks
    self.checks.map(&:perform_check).compact
  end

  def self.lookup_class(name_or_class)
    return name_or_class if name_or_class.respond_to?(:new)
    "Healthchecker::#{name_or_class.to_s.capitalize}Check".constantize
  end
end
