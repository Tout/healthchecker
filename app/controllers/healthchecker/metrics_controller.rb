module Healthchecker
  class MetricsController < ActionController::Base

    def show
      render json: current_status
    end

    def current_status
      {
        redis: {
          ok: (Redis.current.ping == 'PONG'),
          config: Redis.current.client.options,
        },
        resque_redis:  {
          ok: (Resque.redis.ping == 'PONG'),
          config: Resque.redis.client.options,
        },
        uptime: (Time.now - Healthchecker::APPLICATION_STARTED_AT),
      }
    end


  end
end
