require 'spec_helper'

describe Healthchecker::Configuration do
  describe '#metrics' do
    it 'default value is [:redis, :resque]' do
      expect(Healthchecker::Configuration.new.metrics).to eq([:redis, :resque])
    end
  end

  describe '#metrics=' do
    it "can set value" do
      config = Healthchecker::Configuration.new
      config.metrics = [:redis, :sidekiq]
      expect(config.metrics).to eq([:redis, :sidekiq])
    end
  end
end
