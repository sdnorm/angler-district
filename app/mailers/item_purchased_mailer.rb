class ItemPurchasedMailer < ApplicationMailer

  def alert_seller seller, order, product, buyer
    @seller = seller
    @order = order
    @product = product
    @buyer = buyer
    puts "I made it to the mailer"
    mail(to: @seller.email, subject: 'An Item You Listed on Angler District has Sold')
  end

end
