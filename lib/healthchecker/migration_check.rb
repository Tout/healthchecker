require 'healthchecker/base_check'

module Healthchecker
  class MigrationCheck < Healthchecker::BaseCheck

    def check!
      ActiveRecord::Migration.check_pending!
    end
  end
end
