require 'spec_helper'

describe Healthchecker::DatabaseCheck do
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
        allow(ActiveRecord::Migrator).to receive(:current_version)
          .and_raise(SQLite3::Exception)
      end

      it 'should raise an error' do
        expect {subject}.to raise_error(SQLite3::Exception)
      end
    end
  end

end
