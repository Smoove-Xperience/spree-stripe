Spree::Core::Engine.routes.draw do
  resource :stripe_payment_verifications, only: [:create]
end
