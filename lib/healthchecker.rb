require "healthchecker/engine"
require 'healthchecker/check'
require 'healthchecker/checks/redis'
require 'healthchecker/checks/migration'
require 'healthchecker/checks/database'
require 'healthchecker/checks/cache'
require 'healthchecker/checks/s3'
require 'healthchecker/checks/solr'
require 'healthchecker/checks/dynamodb'

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
    "Healthchecker::Checks::#{name_or_class.to_s.capitalize}".constantize
  end
end
