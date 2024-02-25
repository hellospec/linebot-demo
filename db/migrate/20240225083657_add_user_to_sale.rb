class AddUserToSale < ActiveRecord::Migration[7.1]
  def change
    add_reference :sales, :user, null: false, foreign_key: true
  end
end
