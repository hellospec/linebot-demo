require "csv"

class CreateRfmOrdersFromUploadJob < ApplicationJob
  queue_as :default

  def perform(rfm_upload_id, csv_body)
    headers = %w(order_number order_date amount customer_name customer_phone)
    table = CSV.parse(csv_body, headers: true)

    order_params = table.map do |row|
      param = row.to_h.extract!(*headers)
      param["rfm_upload_id"] = rfm_upload_id
      param
    end
    RfmOrder.insert_all order_params
  end
end
