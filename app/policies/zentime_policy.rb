class ZentimePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.regular?
        user.zentimes.all
      end
    end
  end

  def index?
    user.regular? || user.admin?
  end

  def create?
    user.regular? || user.admin?
  end

  def show?
    owner? || user.admin?
  end

  def update?
    owner? || user.admin?
  end

  def destroy?
    owner? || user.admin?
  end

  private

  def owner?
    user.regular? && user.id == record.user_id
  end
end
