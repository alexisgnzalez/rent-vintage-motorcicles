class Offer < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many_attached :photos
  validates :price, :long, :lat, :description, presence: true
  validates :price, inclusion: 5..15
  validates :description, length: { minimum: 8 }
  pg_search_scope :search_by_description,
    against: [ :description ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
