class AddLineUserIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :line_user_id, :string
    add_column :users, :line_display_name, :string
    add_column :users, :line_picture_url, :string
  end
end
