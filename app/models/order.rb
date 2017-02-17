class Order < ApplicationRecord

  validates :address, :city, :state, presence: true

  belongs_to :product
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"

  # def paypal_url(return_path, seller_email, seller_amount, ad_amount)
  #   values = [
  #       {
  #         business: seller_email,#"merchant@gotealeaf.com",
  #         cmd: "_xclick",
  #         upload: 1,
  #         return: "#{Rails.application.secrets.app_host}#{return_path}",
  #         invoice: id,
  #         amount: course.price,
  #         item_name: course.name,
  #         item_number: course.id,
  #         quantity: '1'
  #       },
  #       {
  #         business: angler_district_email,
  #         cmd: "_xclick",
  #         upload: 1,
  #         return: "#{Rails.application.secrets.app_host}#{return_path}",
  #         invoice: id,
  #         amount: course.price,
  #         item_name: course.name,
  #         item_number: course.id,
  #         quantity: '1'
  #       }
  #   ]
  #   "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  # end

end
