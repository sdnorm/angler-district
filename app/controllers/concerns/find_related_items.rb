module FindRelatedItems

  def find_related_items products
    @related_products ||= Array.new
    # puts products.class if products.class.to_s == "Product"
    case products.class.to_s
    when "Product"
      @related_products.push(Category.find(products.category_id).products.order("RANDOM()").limit(3)) unless products.category_id.nil?
    else
      if products.length == 1
        # find_categories(products.first)
        @related_products.push(Category.find(products.first.category_id).products.order("RANDOM()").limit(3)) unless products.first.category_id.nil?
      else
        products.each do |product|
          find_categories(product)
        end
        @category_ids.each do |category|
          @related_products.push(Category.find(category).products.order("RANDOM()").limit(3))
        end unless @category_ids.nil?
      end
    end
    @related_products
  end

  def find_categories product
    @category_ids ||= Array.new
    unless product.category_id.nil? || @category_ids.include?(product.category_id)
      @category_ids << product.category_id
    end
    @category_ids
  end

end
