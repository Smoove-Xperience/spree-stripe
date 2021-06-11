module Spree
  module Stripe
    class Engine < ::Rails::Engine
      require 'spree/core'
      
      engine_name "spree-stripe"

      isolate_namespace Spree::Stripe

      initializer "spree.spree-stripe.payment_methods", :after => "spree.register.payment_methods" do |app|
        app.config.spree.payment_methods << Gateway::StripeGateway
      end

      def self.activate
        Spree::PermittedAttributes.source_attributes << :methodid
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
