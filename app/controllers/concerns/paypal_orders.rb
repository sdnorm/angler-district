module PaypalOrders

  def PaypalOrders.run orders
    orders.product.user.where.not(paypal_email: nil)
  end

end
