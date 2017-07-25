require 'healthchecker/base_check'

module Healthchecker
  class DynamodbCheck < BaseCheck

    def client
      options[:client] || Aws::DynamoDB::Client.new
    end

    def check!
      client.list_tables
      nil
    end
  end
end
