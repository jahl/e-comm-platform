# frozen_string_literal: true

require 'rails_helper'
require 'aws-sdk-s3'

RSpec.describe S3::UploadFile, type: :service do
  let(:file) do
    instance_double('ActionDispatch::Http::UploadedFile',
                    original_filename: 'test_file.csv',
                    read: 'file_content')
  end
  let(:s3_client) { instance_double(Aws::S3::Client) }
  subject { described_class }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    allow(Time).to receive(:now).and_return(Time.zone.at(1_000_000))
  end

  describe '#run' do
    it 'uploads a file to S3' do
      expect(s3_client).to receive(:put_object).with(
        bucket: ENV['AWS_BUCKET_NAME'],
        key: "#{Time.now.to_i}_#{file.original_filename}",
        body: file.read,
        acl: 'public-read'
      )

      subject.run(file)
    end
  end

  describe '#file_key' do
    it 'genereates a file key based on the file name and current time' do
      expect(subject.new(file).send(:file_key)).to eq('1000000_test_file.csv')
    end
  end
end
