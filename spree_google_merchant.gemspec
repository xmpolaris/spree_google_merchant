$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spree_google_merchant/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spree_google_merchant"
  s.version     = SpreeGoogleMerchant::VERSION
  s.authors     = ["Seb Weston, Chen ZhongXue"]
  s.email       = ["sebweston@gmail.com, xmpolaris@gmail.com"]
  s.homepage    = "https://github.com/xmpolaris/spree_google_merchant"
  s.summary     = "GoogleMerchant feeds extension(spree 1.2)"
  s.description = "GoogleMerchant feeds extension(spree 1.2)"

  s.files = Dir["{app,config,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_runtime_dependency "spree", "~> 1.2"
end
