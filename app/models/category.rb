class Category < ApplicationRecord

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products

  scope :reels, -> { where(name: "Reels").includes(:products) }
  scope :rods, -> { where(name: "Rods").includes(:products) }
  scope :lures, -> { where(name: "Lures").includes(:products) }
  scope :electronics, -> { where(name: "electronics").includes(:products) }
  scope :boating, -> { where(name: "Boating").includes(:products) }
  scope :general, -> { where(name: "General").includes(:products) }
  scope :apparel, -> { where(name: "Apparel").includes(:products) }

end
