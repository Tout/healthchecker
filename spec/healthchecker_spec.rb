require 'spec_helper'

class CustomCheck < Healthchecker::Check
  def check!

  end
end
describe Healthchecker do

  describe '.add_check' do
    let(:options) { {} }
    subject { described_class.add_check(check_name, options)}

    before do
      described_class.checks = []
    end

    after do
      described_class.checks = []
    end

    [:redis, :migration, :database, :s3, :cache].each do |check|
      context "#{check.inspect}" do
        let(:check_name) { check }
        it 'should add the check' do
          subject
          expect(described_class.checks.last).to be_a("Healthchecker::Checks::#{check.to_s.capitalize}".constantize)
        end
      end
    end

    context 'custom check' do
      let(:check_name) { CustomCheck }

      it 'should initialize with options' do
        expect(check_name).to receive(:new).with(options.merge(check: check_name))
        subject
      end

      it 'should add it to the check list' do
        subject
        expect(described_class.checks.last).to be_a(check_name)
      end
    end
  end

  describe '.perform_checks' do
    let(:check) { CustomCheck.new({}) }
    subject { described_class.perform_checks }

    before { described_class.checks = [check] }

    it 'should call check! on the check' do
      expect(check).to receive(:check!)
      subject
    end

    context 'when an error is raised' do
      before do
        allow(check).to receive(:check!).and_raise(Redis::TimeoutError.new('error'))
      end

      it 'should return the error in the result' do
        expect(subject.first[0]).to eq(Redis::TimeoutError)
        expect(subject.first[1]).to eq('error')
        expect(subject.first[2]).to eq({})
      end
    end
  end

  describe '.configure' do
    before do
      Healthchecker.configure do |config|
        config.metrics = [:redis, :sidekiq]
      end
    end

    it 'sets configuration' do
      expect(Healthchecker.configuration.metrics).to eq([:redis, :sidekiq])
    end

    after do
      Healthchecker.reset
    end
  end

end
