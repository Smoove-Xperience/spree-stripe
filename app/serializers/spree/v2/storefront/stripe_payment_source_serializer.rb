module Spree
  module V2
    module Storefront
      class StripePaymentSourceSerializer < BaseSerializer
        attributes :intent_key, :ephemeral_key

        attribute :customer_id do |source|
          source.user.stripe_customer_id
        end
      end
    end
  end
end
