module Healthchecker
  class HealthController < ActionController::Base

    def show
      checks = Healthchecker.perform_checks
      render status: 500, json: {status: checks} and return unless checks.empty?
      render json: {status: 'ok'}
    end
  end
end
