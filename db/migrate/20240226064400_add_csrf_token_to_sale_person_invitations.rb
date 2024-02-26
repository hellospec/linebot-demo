class AddCsrfTokenToSalePersonInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :sale_person_invitations, :csrf_token, :string
  end
end
