require 'spec_helper'

describe Healthchecker::MetricsController do
  describe '#current_status' do
    let(:generic_payload) do
      { ok: true, config: { foo: 'baz' } }
    end
    let(:redis) do
      { redis: generic_payload }
    end
    let(:resque) do
      { resque_redis: generic_payload }
    end
    let(:sidekiq) do
      { sidekiq_redis: generic_payload }
    end

    before do
      allow(Healthchecker::MetricsController::ConfigurableMetrics).to receive(:redis).and_return(redis)
      allow(Healthchecker::MetricsController::ConfigurableMetrics).to receive(:resque).and_return(resque)
      allow(Healthchecker::MetricsController::ConfigurableMetrics).to receive(:sidekiq).and_return(sidekiq)
    end

    context 'when default configuration for metrics' do
      it 'should show default metrics' do
        status = Healthchecker::MetricsController.new.current_status
        expect(status).to include(redis, resque)
        expect(status).not_to include(sidekiq)
      end
    end

    context 'when custom configuration for metrics' do
      before do
        Healthchecker.configure do |config|
          config.metrics = [:redis, :sidekiq]
        end
      end

      it 'should show configured metrics' do
        status = Healthchecker::MetricsController.new.current_status
        expect(status).to include(redis, sidekiq)
        expect(status).not_to include(resque)
      end

      after do
        Healthchecker.reset
      end
    end

    context 'when metrics configured with empty array []' do
      before do
        Healthchecker.configure do |config|
          config.metrics = []
        end
      end

      it 'should show only uptime' do
        status = Healthchecker::MetricsController.new.current_status
        expect(status).to include(:uptime)
        expect(status).not_to include(redis, resque, sidekiq)
      end

      after do
        Healthchecker.reset
      end
    end
  end
end