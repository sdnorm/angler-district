module ApplicationHelper

  def ApplicationHelper.value order_value, user_value
    if order_value.blank?
      user_value
    else
      order_value
    end
  end

end
