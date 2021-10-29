class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :offers # Owner of a bike
  has_one_attached :photo
  # Tomorrow morning you should ask a question about all this
  # You should add this if you want to rent your bike
  has_many :bookings # Want to rent a bike
  # You should add this if you want to use the bike
  # has_many :offers, through: :bookings # Want to rent this bike
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { minimum: 3 }
end
