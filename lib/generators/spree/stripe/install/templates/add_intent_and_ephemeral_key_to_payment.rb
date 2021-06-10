class AddIntentAndEphemeralKeyToPayment < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_payments, :stripe_intent_key, :string
    add_column :spree_payments, :stripe_ephemeral_key, :string
  end
end
