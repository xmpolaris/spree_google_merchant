Spree::ProductsController.class_eval do
  def google_merchant
    @taxons = Spree::Taxon.all.inject({}) {|a,b| a.merge({b.id.to_s => b.pretty_name})}
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
      spree_assets.attachment_file_name as img_name'
    ).group('spree_products.id').active
  end

  protected
  def google_merchant_product_type(product)
    ancestor_chain = product.ancestors.inject("") do |name, ancestor|
      name += "#{ancestor.name} > "
    end
    ancestor_chain + "#{name}"
  end
end

