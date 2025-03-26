module CmAdmin
  class UserPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      index?
    end

    def create?
      index?
    end

    def update?
      index?
    end

    def destroy?
      index?
    end

    def history?
      index?
    end
  end
end
