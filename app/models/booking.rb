class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :offer
  validates :start_date, :end_date, presence: true, uniqueness: true
  scope :overlapping, ->(start_date, end_date) do
    where "((start_date <= ?) and (end_date >= ?))", end_date, start_date
  end
end
