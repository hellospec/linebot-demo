class AddSlugToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :slug, :string
  end
end
