require "csv"

class RfmUploadsController < ApplicationController
  def index
    @rfm_uploads = RfmUpload.all
  end

  def new
  end

  def create
    name = params[:rfm_upload][:file].original_filename
    uploaded_file = params[:rfm_upload][:file].tempfile
    body = uploaded_file.read

    rfm_upload = RfmUpload.new(name: name, body: body)
    if rfm_upload.save
      # Run background job that extract item in the file and create
      # each RfmOrder record
      headers = %w(order_number order_date amount customer_name customer_phone)
      table = CSV.parse(body, headers: true)

      order_params = table.map { |row| row.to_h.extract!(*headers) }
      RfmOrder.insert_all order_params

      redirect_to rfm_path, status: :see_other
    end
  end
end
