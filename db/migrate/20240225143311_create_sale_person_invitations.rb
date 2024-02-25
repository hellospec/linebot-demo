class CreateSalePersonInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :sale_person_invitations do |t|
      t.string :code
      t.date :expires_at
      t.string :status, null: false, default: "fresh"
      t.integer :user_id

      t.timestamps
    end
  end
end
