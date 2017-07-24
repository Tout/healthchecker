require 'healthchecker/base_check'

module Healthchecker
  class RedisCheck < Healthchecker::BaseCheck

    def check!
      client = options[:client] || Redis.new
      result = client.ping
      return if result == 'PONG'
      raise "Redis returned #{result.inspect} instead of PONG"
    end
  end
end
