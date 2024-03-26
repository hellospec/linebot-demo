class RfmUploadsController < ApplicationController
  before_action :authenticate_sale_person

  def index
    @rfm_uploads = RfmUpload.all
  end

  def new
  end

  def create
    uploaded_file = params[:rfm_upload][:file].tempfile
    csv_filename = params[:rfm_upload][:file].original_filename
    csv_body = uploaded_file.read

    rfm_upload = RfmUpload.new(name: csv_filename, body: csv_body)
    if rfm_upload.save
      CreateRfmOrdersFromUploadJob.perform_later(rfm_upload.id)
    end

    redirect_to root_path, status: :see_other
  end
end
