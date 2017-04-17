class Brand < ApplicationRecord

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products

  scope :thirteen_fishing, -> { where(name: "Reels").includes(:products) }
  scope :abu_garcia, -> { where(name: "Rods").includes(:products) }
  scope :lures, -> { where(name: "Lures").includes(:products) }
  scope :electronics, -> { where(name: "electronics").includes(:products) }
  scope :boating, -> { where(name: "Boating").includes(:products) }
  scope :general, -> { where(name: "General").includes(:products) }
  scope :apparel, -> { where(name: "Apparel").includes(:products) }

  scope :freshwater, -> { where(fresh: true) }
  scope :saltwarer, -> { where(salt: true) }
end
