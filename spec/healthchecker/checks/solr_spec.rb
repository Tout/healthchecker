require 'spec_helper'

describe Healthchecker::Checks::Solr do
  let(:client) { double(head: response) }
  let(:response) { double(response: {status: status}) }
  let(:status) { 200 }
  let(:options) { {rsolr_client: client} }
  let(:test_inst) { described_class.new(options) }

  describe '#check!' do
    subject {described_class.new(options).check!}

    context 'when check passes' do

      it 'should not raise an error' do
        expect {subject}.not_to raise_error
      end
    end

    context 'when check fails' do
      context 'when invalid response' do
        let(:status) { 500 }

        it 'should raise an error' do
          expect {subject}.to raise_error(RuntimeError)
        end
      end

      context 'with raised error' do
        before do
          allow(client).to receive(:head).and_raise(RSolr::Error::ConnectionRefused)
        end

        it 'should raise an error' do
          expect {subject}.to raise_error(RSolr::Error::ConnectionRefused)
        end
      end
    end
  end

end
