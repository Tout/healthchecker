require 'healthchecker/base_check'

module Healthchecker
  class DynamodbCheck < BaseCheck

    def client
      options[:client] || Aws::Dynamodb::Client.new
    end

    def check!
      client.list_tables
      nil
    end
  end
end
