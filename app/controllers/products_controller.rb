# frozen_string_literal: true

class ProductsController < ApplicationController
  # POST /products/import
  def import
    file = params[:file]

    raise 'No file provided' unless file
    raise 'Invalid file type, please upload a CSV.' unless file.content_type == 'text/csv'

    file_key = S3::UploadFile.run(file)
    Products::ImportJob.perform_async(file_key)
    render json: { message: 'Your file was uploaded successfully, inventory will be processed shortly' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
