class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where.not(id: user.id) unless user.regular?
    end
  end

  def index?
    allowed_users?
  end

  def show?
    allowed_users?
  end

  def update?
    allowed_users?
  end

  def create?
    allowed_users?
  end

  def destroy?
    not_my_user? && allowed_users?
  end

  private

  def not_my_user?
    user.id != record.id
  end

  def allowed_users?
    user.manager? || user.admin?
  end
end
