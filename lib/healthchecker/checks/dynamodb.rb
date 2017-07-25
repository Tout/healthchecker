require 'healthchecker/check'

module Healthchecker::Checks
  class Dynamodb < Healthchecker::Check

    def client
      options[:client] || Aws::DynamoDB::Client.new
    end

    def check!
      client.list_tables
      nil
    end
  end
end
