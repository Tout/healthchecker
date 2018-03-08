module Healthchecker
  class ConfigurationError < StandardError; end

  class Configuration
    attr_accessor :metrics

    def initialize
      @metrics = [:redis, :resque]
    end
  end
end