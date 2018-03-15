class ReportPolicy < ApplicationPolicy
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
end
