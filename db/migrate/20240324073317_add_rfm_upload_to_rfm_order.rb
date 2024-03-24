class AddRfmUploadToRfmOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :rfm_orders, :rfm_upload, null: false, foreign_key: true
  end
end
