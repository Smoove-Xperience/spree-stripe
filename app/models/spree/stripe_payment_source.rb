module Spree
  class StripePaymentSource < Spree::Base
    belongs_to :payment_method
    belongs_to :user
    has_one :payment, as: :source
  end
end
