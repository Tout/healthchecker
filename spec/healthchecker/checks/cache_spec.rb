require 'spec_helper'

describe Healthchecker::Checks::Cache do
  let(:options) { {} }
  let(:test_inst) { described_class.new(options) }

  describe '#check!' do
    subject {described_class.new(options).check!}

    context 'when check passes' do
      before do
        allow(Rails.cache).to receive(:write).and_return(true)
      end

      it 'should not raise an error' do
        expect {subject}.not_to raise_error
      end
    end

    context 'when check fails' do
      before do
        allow(Rails.cache).to receive(:write).and_return(false)
      end

      it 'should raise an error' do
        expect {subject}.to raise_error(RuntimeError)
      end
    end
  end

end
