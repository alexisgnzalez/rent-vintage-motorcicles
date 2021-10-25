class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :offers
  # Tomorrow morning you should ask a question about all this
  # You should add this if you want to rent your bike
  ## has_many :bookings ##
  # You should add this if you want to use the bike
  ## has_many :offers, through: :bookings ##
end
