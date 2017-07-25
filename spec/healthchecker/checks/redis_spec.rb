require 'spec_helper'

describe Healthchecker::Checks::Redis do
  let(:client) { Redis.new }
  let(:options) { {client: client} }
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
        before do
          allow(client).to receive(:ping).and_return('PUNG')
        end

        it 'should raise an error' do
          expect {subject}.to raise_error(RuntimeError)
        end
      end

      context 'with raised error' do
        before do
          allow(client).to receive(:ping).and_raise(Redis::CannotConnectError)
        end

        it 'should raise an error' do
          expect {subject}.to raise_error(Redis::CannotConnectError)
        end
      end
    end
  end

end
