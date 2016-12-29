class Product < ApplicationRecord

  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  belongs_to :user
  has_many :orders

  def cart_action(current_user_id)
    if $redis.sismember "cart#{current_user_id}", id
      "Remove from"
    else
      "Add to"
    end
  end

end
