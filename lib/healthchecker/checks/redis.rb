require 'healthchecker/check'

module Healthchecker::Checks
  class Redis < Healthchecker::Check

    def check!
      client = options[:client] || Redis.new
      result = client.ping
      return if result == 'PONG'
      raise "Redis returned #{result.inspect} instead of PONG"
    end
  end
end
