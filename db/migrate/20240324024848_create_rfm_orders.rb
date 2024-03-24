class CreateRfmOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :rfm_orders do |t|
      t.string :order_number
      t.date :order_date
      t.integer :amount
      t.string :customer_name
      t.string :customer_phone

      t.timestamps
    end
  end
end
