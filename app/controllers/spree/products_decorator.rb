Spree::ProductsController.class_eval do
  def google_merchant
    @taxons = Spree::Taxon.all.inject({}) {|a,b| a.merge({b.id.to_s => google_merchant_product_type(b)})}
    product_properties = Spree::ProductProperty.includes(:property)
    property_mpn = Spree::Property.where(:name => 'mpn').first.try(&:id)
    property_brand = Spree::Property.where(:name => 'brand').first.try(&:id)
    property_manufacturer = Spree::Property.where(:name => 'manufacturer').first.try(&:id)

    @product_brands = product_properties.where("spree_proterties.name = 'brand'")
    @product_manufacturers = product_properties.where("spree_proterties.name = 'manufacturer'")
    @products = Spree::Product.joins(
      "LEFT JOIN `spree_variants` ON
        `spree_variants`.`product_id` = `spree_products`.`id` AND 
        `spree_variants`.`is_master` = 1"
    ).joins(
      "LEFT JOIN `spree_assets` ON
        `spree_assets`.`viewable_id` = `spree_variants`.`id` AND
        `spree_assets`.`type` = 'Spree::Image' AND
        `spree_assets`.`viewable_type` = 'Spree::Variant'"
    ).joins(
      "LEFT JOIN `spree_products_taxons` ON
        `spree_products_taxons`.`product_id` = `spree_products`.`id`"
    ).select(
      'spree_products.id as id,
      spree_products.name as name,
      spree_products.permalink as permalink,
      spree_products.description as description,
      spree_variants.sku as v_sku,
      spree_variants.price as v_price,
      spree_variants.count_on_hand as v_count_on_hand,
      spree_products_taxons.taxon_id as v_taxon_id,
      spree_assets.id as img_id,
      spree_assets.attachment_file_name as img_name'
    ).group('spree_products.id').active

    if property_mpn
      @products = @products.joins(
        "LEFT JOIN `spree_product_properties` as spree_mpns ON
          `spree_mpns`.`product_id` = `spree_products`.`id` AND
          `spree_mpns`.`property_id` = #{property_mpn}"
      ).select("spree_mpns.value as v_mpn")
    end
    if property_brand
      @products = @products.joins(
        "LEFT JOIN `spree_product_properties` as spree_brands ON
          `spree_brands`.`product_id` = `spree_products`.`id` AND
          `spree_brands`.`property_id` = #{property_brand}"
      ).select("spree_brands.value as v_brand")
    end
    if property_manufacturer
      @products = @products.joins(
        "LEFT JOIN `spree_product_properties` as spree_mus ON
          `spree_mus`.`product_id` = `spree_products`.`id` AND
          `spree_mus`.`property_id` = #{property_manufacturer}"
      ).select("spree_mus.value as v_manufacturer")
    end
  end

  protected
  def google_merchant_product_type(taxon)
    ancestor_chain = taxon.ancestors.inject("") do |name, ancestor|
      name += "#{ancestor.name} > "
    end
    ancestor_chain + "#{taxon.name}"
  end
end


