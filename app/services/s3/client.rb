# frozen_string_literal: true

module S3
  module Client
    extend ActiveSupport::Concern

    def client
      @client ||= ::Aws::S3::Client.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end
  end
end
