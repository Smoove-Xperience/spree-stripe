module Spree
  module V2
    module Storefront
      class StripePaymentSourceSerializer < BaseSerializer
        attributes :intent_key

        attribute :customer_id do |source|
          source.user.stripe_customer_id
        end

        attribute :ephemeral_key do |source|
          source.payment_method.create_ephemeral_key(source)
        end
      end
    end
  end
end
