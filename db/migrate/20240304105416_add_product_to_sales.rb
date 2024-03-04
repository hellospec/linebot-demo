class AddProductToSales < ActiveRecord::Migration[7.1]
  def up
    add_reference :sales, :product

    Sale.all.each do |s|
      p = Product.find_by(code: s.product_code)
      s.product_id = p.id
      s.save
    end

    add_index :sales, :product_id, if_not_exists: true
    add_foreign_key :sales, :products, if_not_exists: true
    remove_column :sales, :product_code, :string
  end

  def down
    add_column :sales, :product_code, :string

    Sale.all.each do |s|
      p = Product.find_by(id: s.product_id)
      s.product_code = p.code
      s.save
    end

    remove_index :sales, :product_id
    remove_foreign_key :sales, :products
    remove_reference :sales, :product
  end
end
