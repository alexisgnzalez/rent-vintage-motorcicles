class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    # true # Anyone can create a bike
    # false
    true
  end
end
