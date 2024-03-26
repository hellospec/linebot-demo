require "csv"

class RfmUpload < ApplicationRecord
  def insert_all!
    headers = %w(order_number order_date amount customer_name customer_phone)
    table = CSV.parse(body, headers: true)

    order_params = table.map do |row|
      param = row.to_h.extract!(*headers)
      next if param["order_date"].blank? || param["amount"].blank?

      param["rfm_upload_id"] = id
      param
    end.compact!
    RfmOrder.insert_all order_params
  end
end
