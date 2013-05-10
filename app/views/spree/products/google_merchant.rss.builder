xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title Spree::GoogleMerchant::Config[:google_merchant_title]
    xml.description Spree::GoogleMerchant::Config[:google_merchant_description]

    production_domain = Spree::GoogleMerchant::Config[:production_domain]
    xml.link production_domain

    currency = Spree::Config.currency

    @products.each do |product|
      brand = product['v_brand']
      brand = product['v_manufacturer'] if brand.blank?
      xml.item do
        xml.title product.name
        xml.description CGI.escapeHTML(product.description)
        xml.link production_domain + 'products/' + product.permalink
        xml.tag! "g:mpn", product['v_mpn'].to_s
        xml.tag! "g:brand", brand
        xml.tag! "g:id", product['v_sku'].to_s
        xml.tag! "g:price", "#{product['v_price']} #{currency}"
        xml.tag! "g:condition", "new"
        xml.tag! "g:image_link", product['img_name'].blank? ? '' : (production_domain.sub(/\/$/, '') + "/spree/products/#{product.id}/product/#{product['img_name']}")
        xml.tag! "g:availability", product['v_count_on_hand'] > 0 ? 'in stock' : 'out of stock'
        xml.tag! "g:product_type", @taxons[product['v_taxon_id'].to_s]
      end
    end
  end
end



