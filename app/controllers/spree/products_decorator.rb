Spree::ProductsController.class_eval do
  def google_merchant
    @products = Spree::Product.includes(:master => :images).active
  end
end
