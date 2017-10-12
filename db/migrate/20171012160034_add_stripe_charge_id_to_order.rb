class AddStripeChargeIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :stripe_charge_id, :string
  end
end
