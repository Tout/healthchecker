require 'healthchecker/check'

module Healthchecker::Checks
  class Database < Healthchecker::Check

    def check!
      return if ActiveRecord::Migrator.current_version
    end
  end
end
