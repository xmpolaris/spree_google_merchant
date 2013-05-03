
module SpreeGoogleMerchant
  class Engine < Rails::Engine
    engine_name 'spree_google_merchant'

    config.autoload_paths += %W(#{config.root}/lib)

    # instantiate the configuration object
    initializer "spree.google_merchant.preferences", :before => :load_config_initializers do |app|
      Spree::GoogleMerchant::Config = Spree::GoogleMerchantConfiguration.new
    end

    config.to_prepare do
      Dir.glob File.expand_path("../../../app/**/*_decorator.rb", __FILE__) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob File.expand_path("../../../app/overrides/**/*.rb", __FILE__) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end
  end
end
