module Spree
  class StripePaymentVerificationsController < BaseController    
    skip_before_action :verify_authenticity_token, only: [:create]

    def create
      event = nil
      payload = request.body.read
      sig_header = request.headers["HTTP_STRIPE_SIGNATURE"]

      
      begin
        event = stripe_provider::Webhook.construct_event(
          payload, sig_header, payment_method.signing_secret
        )
      rescue JSON::ParserError => e
        head :bad_request
        return
      rescue stripe_provider::SignatureVerificationError => e
        head :bad_request
        return
      end

      intent = event.data.object
      source = StripePaymentSource.find_by(intent_key: intent.client_secret)

      if (source.present?)
        @payment = source.payment
  
        case event.type
          when 'payment_intent.processing'
            transition_to_pending!
          when 'payment_intent.succeeded'
            transition_to_paid!
          when 'payment_intent.canceled'
            transition_to_failed!
        end
        
        source.update(status: intent.status)
        head :ok
      else
        head :not_found
      end
    end

    private

    def payment_method
      Spree::PaymentMethod.find_by_type 'Spree::Gateway::StripeGateway'
    end

    def stripe_provider
      ::Stripe.api_key = payment_method.secret_key

      ::Stripe
    end

    def transition_to_pending!
      @payment.pend! unless @payment.pending?
    end

    def transition_to_paid!
      return if @payment.completed?

      @payment.complete!
    end

    def transition_to_failed!
      return if @payment.failed?

      @payment.failure!
      @payment.order.update(shipment_state: "canceled")
    end
  end
end
