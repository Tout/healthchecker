require 'healthchecker/check'

module Healthchecker::Checks
  class Solr < Healthchecker::Check

    def client
      if options[:rsolr_client]
        options[:rsolr_client] 
      elsif options[:url]
        RSolr.connect(url: options[:url])
      else
        Sunspot::Session.new.send(:connection)
      end
    end

    def check!
      ping_success = client.head("admin/ping", :headers => {"Cache-Control" => "If-None-Match"}).response[:status] == 200
      raise "Could not connect to solr" unless ping_success
    end
  end
end
