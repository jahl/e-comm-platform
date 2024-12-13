# frozen_string_literal: true

require 'csv'

module Products
  class ImportJob < ApplicationJob
    def perform(file_uri)
      file_data = S3::FetchFile.run(file_uri)
      imported_csv = CSV.parse(file_data, headers: true)
      Products::ImportFromCsv.run(imported_csv)
    end
  end
end
