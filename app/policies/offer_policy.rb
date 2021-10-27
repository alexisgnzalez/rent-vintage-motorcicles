class OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def create?
    true # Anyone can create a bike
  end

  def show?
    true # Anyone can view an bike
  end
end
