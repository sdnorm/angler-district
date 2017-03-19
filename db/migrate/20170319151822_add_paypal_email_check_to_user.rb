class AddPaypalEmailCheckToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :paypal_email_the_same, :boolean
  end
end
