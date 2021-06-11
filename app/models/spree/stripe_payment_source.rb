module Spree
  class StripePaymentSource < Spree::Base
    belongs_to :payment_method
    belongs_to :user
    has_many :payments, as: :source
  end
end
