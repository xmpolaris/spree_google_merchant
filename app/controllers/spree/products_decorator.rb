Spree::ProductsController.class_eval do
  def google_merchant
    @products = Spree::Product.joins(
      "LEFT JOIN `spree_variants` ON
        `spree_variants`.`product_id` = `spree_products`.`id` AND 
        `spree_variants`.`is_master` = 1"
    ).joins(
      "LEFT JOIN `spree_assets` ON
        `spree_assets`.`viewable_id` = `spree_variants`.`id` AND
        `spree_assets`.`type` = 'Spree::Image' AND
        `spree_assets`.`viewable_type` = 'Spree::Variant'"
    ).select(
      'spree_products.id as id,
      spree_products.name as name,
      spree_products.permalink as permalink,
      spree_products.description as description,
      spree_variants.sku as v_sku,
      spree_variants.price as v_price,
      spree_assets.attachment_file_name as img_name'
    ).group('spree_products.id').active
  end
end
