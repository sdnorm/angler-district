module FindRelatedItems

  def find_related_items products
    @related_products ||= Array.new
    puts "thing to inspect"
    puts products.inspect
    puts "end"
    if products.length == 1
      find_categories(products.first)
      @related_products.push(Category.find(category).products.order("RANDOM()").limit(3))
    else
      products.each do |product|
        find_categories(product)
      end
      @category_ids.each do |category|
        @related_products.push(Category.find(category).products.order("RANDOM()").limit(3))
      end unless @category_ids.nil?
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
