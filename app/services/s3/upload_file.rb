# frozen_string_literal: true

module S3
  class UploadFile < Base
    attr_reader :file, :file_key

    def initialize(file)
      @file = file
      @file_key = generate_file_key
    end

    def run
      upload
    end

    private

    def upload
      client.put_object(
        bucket: ENV['AWS_BUCKET_NAME'],
        key: file_key,
        body: file.read,
        acl: 'public-read'
      )

      file_key
    end

    def generate_file_key
      "#{Time.now.to_i}_#{file.original_filename}"
    end
  end
end
