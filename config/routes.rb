Spree::Core::Engine.routes.prepend do
  match '/google_merchant' => 'products#google_merchant'

  namespace :admin do
    resource :google_merchants
  end
end
