module Spree
  # Gateway for card payment method using stripe
  class Gateway::StripeGateway < PaymentMethod
    attr_accessor :publishable_key, :secret_key
    
    preference :publishable_key, :string
    preference :secret_key, :string

    def publishable_key
      ENV['PUBLISHABLE_KEY'] || preferred_publishable_key
    end

    def secret_key
      ENV['SECRET_KEY'] || preferred_secret_key
    end

    def provider_class
      self.class
    end

    def source_required?
      false
    end

    def auto_capture?
      false
    end

    def actions
      %w{void}
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      !payment.void?
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

    def method_type
      "stripe"
    end

    def purchase(amount, source, options = {})
      binding.pry
    end

    def authorize(amount, source, options = {})
      binding.pry
      if (response.status == 200)
        ActiveMerchant::Billing::Response.new(true, 'Stripe payment intent created')
      else
        ActiveMerchant::Billing::Response.new(false, 'Failed to create stripe payment intent')
      end
    end

    def capture(*_args)
      ActiveMerchant::Billing::Response.new(true, 'Stripe will automatically capture the amount after creating a shipment.')
    end
  end
end
