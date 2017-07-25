require 'spec_helper'

describe Healthchecker::DynamodbCheck do
  let(:client) { double(list_tables: true) }
  let(:options) { {client: client} }

  describe '#check!' do
    subject {described_class.new(options).check!}

    context 'when check passes' do

      it 'should not raise an error' do
        expect {subject}.not_to raise_error
      end
    end

    context 'when check fails' do
      before do
        allow(client).to receive(:list_tables).and_raise(Aws::Errors::ServiceError.new({}, 'error'))
      end

      it 'should raise an error' do
        expect {subject}.to raise_error(Aws::Errors::ServiceError)
      end
    end
  end

end
