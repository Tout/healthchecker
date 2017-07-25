require 'healthchecker/check'

module Healthchecker::Checks
  class Cache < Healthchecker::Check

    def check!
      return if Rails.cache.write(cache_key, 'ok', :expires_in => 1.second)
      raise 'Unable to write to rails cache.'
    end

    def cache_key
      options[:cache_key] || SecureRandom.hex
    end
  end
end
