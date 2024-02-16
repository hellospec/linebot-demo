class CreateSales < ActiveRecord::Migration[7.1]
  def change
    create_table :sales do |t|
      t.integer :amount
      t.string :sale_person_line_id
      t.string :product_code
      t.string :channel_code

      t.timestamps
    end
  end
end
