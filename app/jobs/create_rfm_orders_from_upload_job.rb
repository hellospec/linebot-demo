class CreateRfmOrdersFromUploadJob < ApplicationJob
  queue_as :default

  def perform(rfm_upload_id)
    rfm_upload = RfmUpload.find rfm_upload_id
    rfm_upload.insert_all!
  end
end
