require 'healthchecker/base_check'

module Healthchecker
  class DatabaseCheck < Healthchecker::BaseCheck

    def check!
      return if ActiveRecord::Migrator.current_version
    end
  end
end
