class RfmUploadsController < ApplicationController
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
      redirect_to rfm_path, status: :see_other
    end
  end
end
