class AddPasswordResetFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_requested_at, :datetime
    add_column :users, :activated, :boolean
    add_column :users, :activation_requested_at, :datetime
  end
end
