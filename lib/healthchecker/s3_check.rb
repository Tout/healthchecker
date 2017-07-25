require 'healthchecker/base_check'

module Healthchecker
  class S3Check < Healthchecker::BaseCheck

    def check!
      options[:buckets].each {|bucket| check_bucket_access(bucket)}
      nil
    end

    def client
      options[:client] || Aws::S3::Client.new
    end

    def check_bucket_access(bucket)
      object_key = options[:object_key] || "healthchecker/#{Time.now.to_i}.json"
      client.put_object(body: 'ok', bucket: bucket, key: object_key)
      raise "Could not read object from bucket '#{bucket}'" unless client.get_object(
        bucket: bucket,
        key: object_key,
      ).body.read == 'ok'
      client.delete_object(bucket: bucket, key: object_key)
    end


  end
end
