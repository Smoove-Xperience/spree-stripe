class CreateStripePaymentSources < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_stripe_payment_sources do |t|
      t.integer :payment_method_id
      t.integer :user_id
      t.string :intent_id
      t.string :intent_key
      t.string :created
      t.string :status
      t.string :methodid
    end
  end
end
