class Product < ApplicationRecord
  mount_uploader :image, ProductImageUploader
  mount_uploader :image2, ProductImageUploader
  mount_uploader :image3, ProductImageUploader
  mount_uploader :image4, ProductImageUploader
  mount_uploader :display_image, DisplayProductImageUploader

  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  belongs_to :user
  has_many :orders

  scope :user_products, -> (user) {
    where(user_id: user).order('created_at DESC')
  }

  scope :positive_inventory, -> { where("inventory > ?", 0) }

  scope :ordered, -> { all.order('created_at DESC') }

  def cart_action(current_user_id)
    if $redis.sismember "cart#{current_user_id}", id
      'Remove from'
    else
      'Add to'
    end
  end

  def set_inventory_to_zero
    self.update(inventory: 0)
  end

  class << self

    def ordered_and_instock
      positive_inventory.ordered
    end

  end
end
