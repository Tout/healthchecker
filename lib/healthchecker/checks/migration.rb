require 'healthchecker/check'

module Healthchecker::Checks
  class Migration < Healthchecker::Check

    def check!
      ActiveRecord::Migration.check_pending!
    end
  end
end
