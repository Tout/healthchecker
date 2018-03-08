module Healthchecker
  class MetricsController < ActionController::Base

    def show
      render json: current_status
    end

    def current_status
      Healthchecker.configuration.metrics.reduce(uptime) { |status, metric|
        if ConfigurableMetrics.method_defined? metric
          status = status.merge(ConfigurableMetrics.send metric)
        else
          supported_metrics = ConfigurableMetrics.public_instance_methods
          message = "#{metric} is not a supported metric. Supported metrics are #{supported_metrics}"
          raise Healthchecker::ConfigurationError, message
        end
        status
      }
    end

    def uptime
      {
        uptime: Time.now - Healthchecker::APPLICATION_STARTED_AT
      }
    end

    module ConfigurableMetrics
      def redis
        {
          redis: {
            ok: Redis.current.ping == 'PONG',
            config: Redis.current.client.options
          }
        }
      end

      def resque
        {
          resque_redis:  {
            ok: Resque.redis.ping == 'PONG',
            config: Resque.redis.client.options
          }
        }
      end

      def sidekiq
        redis = Sidekiq.redis { |conn| conn }

        {
          sidekiq_redis: {
            ok: redis.ping == 'PONG',
            config: redis.client.options
          }
        }
      end
    end
  end
end
