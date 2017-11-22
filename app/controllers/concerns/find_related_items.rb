module FindRelatedItems

  def find_related_items products
    if products.length == 1
      find_categories(products.first)
    else
      products.each do |product|
        find_categories(product)
      end
    end
    related_products = []
    @category_ids.each do |category|
      related_products << Category.find(category).products.order("RANDOM()").limit(3)
    end
    related_products
  end

  def find_categories product
    @category_ids = []
    unless product.category_id.nil? || @category_ids.include?(product.category_id)
      @category_ids << product.category_id
    end
    @category_ids
  end

end
