class Category < ApplicationRecord

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products#, through: :product_categories
  has_many :product_categories

  scope :reels, -> { where(name: "Reels").includes(:products) }
  scope :rods, -> { where(name: "Rods").includes(:products) }
  scope :lures, -> { where(name: "Lures").includes(:products) }
  scope :electronics, -> { where(name: "Electronics").includes(:products) }
  scope :boating, -> { where(name: "Boating").includes(:products) }
  scope :general, -> { where(name: "General").includes(:products) }
  scope :apparel, -> { where(name: "Apparel").includes(:products) }
  scope :freshwater, -> { where(name: "Freshwater").includes(:products) }
  scope :saltwater, -> { where(name: "Saltwater").includes(:products) }

  class << self
    def fresh_rods
      rods.freshwater
    end
  end

end
