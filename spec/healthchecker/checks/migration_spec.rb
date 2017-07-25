require 'spec_helper'

describe Healthchecker::Checks::Migration do
  let(:options) { {} }
  let(:test_inst) { described_class.new(options) }

  describe '#check!' do
    subject {described_class.new(options).check!}

    context 'when check passes' do

      it 'should not raise an error' do
        expect {subject}.not_to raise_error
      end
    end

    context 'when check fails' do
      before do
        allow(ActiveRecord::Migration).to receive(:check_pending!)
          .and_raise(ActiveRecord::PendingMigrationError)
      end

      it 'should raise an error' do
        expect {subject}.to raise_error(ActiveRecord::PendingMigrationError)
      end
    end
  end

end
