class Offer < ApplicationRecord
  belongs_to :user
  has_many :bookings
  validates :price, :long, :lat, :description, presence: true
  validates :price, inclusion: 5..15
  validates :description, length: { minimum: 8 }
end
