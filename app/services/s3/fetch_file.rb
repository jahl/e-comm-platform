# frozen_string_literal: true

module S3
  class FetchFile < Base
    attr_reader :file_key

    def initialize(file_key)
      @file_key = file_key
    end

    def run
      download
    end

    private

    def download
      response = client.get_object(
        bucket: ENV['AWS_BUCKET_NAME'],
        key: file_key
      )

      response.body.read
    end
  end
end
