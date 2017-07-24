require 'spec_helper'

describe Healthchecker::S3Check do
  let(:fake_s3) { Aws::S3::Client.new(stub_responses: fake_s3_client_stubs)}
  let(:options) { {buckets: ['test_1', 'test_2'], client: fake_s3} }
  let(:test_inst) { described_class.new(options) }

  describe '#check!' do
    subject {described_class.new(options).check!}

    context 'when check passes' do
      let(:fake_s3_client_stubs) do
        {
          get_object: {
            body: 'ok'
          },
          delete_object: true,
          put_object: true
        }
      end

      it 'should not raise an error' do
        expect {subject}.not_to raise_error
      end
    end

    context 'when check fails' do
      let(:fake_s3_client_stubs) do
        {
          get_object: Aws::Errors::MissingCredentialsError,
          delete_object: true,
          put_object: true
        }
      end

      it 'should raise an error' do
        expect {subject}.to raise_error(Aws::Errors::MissingCredentialsError)
      end
    end
  end

end
