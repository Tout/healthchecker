module Healthchecker
  class BaseCheck
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def check!; raise NotImplementedError; end

    def perform_check
      check!
    rescue RuntimeError => e
      [e.class, e.message, options]
    end
  end
end
