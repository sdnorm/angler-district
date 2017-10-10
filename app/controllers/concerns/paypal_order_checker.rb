module PaypalOrderChecker

  def PaypalOrderChecker.run order
    if order.count > 0
      true
    else
      false
    end
  end

end
