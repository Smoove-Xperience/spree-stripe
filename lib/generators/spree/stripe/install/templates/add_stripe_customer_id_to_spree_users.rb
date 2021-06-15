class AddStripeCustomerIdToSpreeUsers < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_users, :stripe_customer_id, :string
  end
end
