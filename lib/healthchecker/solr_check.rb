require 'healthchecker/base_check'

module Healthchecker
  class SolrCheck < BaseCheck

    def client
      options[:rsolr_client] || Sunspot::Session.new.send(:connection)
    end

    def check!
      ping_success = client.head("admin/ping", :headers => {"Cache-Control" => "If-None-Match"}).response[:status] == 200
      raise "Could not connect to solr" unless ping_success
    end
  end
end
