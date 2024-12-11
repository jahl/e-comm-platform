# frozen_string_literal: true

module S3
  class Base < ApplicationService
    include S3::Client
  end
end
