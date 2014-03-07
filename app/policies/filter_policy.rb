class FilterPolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve

      if authenticated?
        user.filters
      elsif user && user.author?
        scope.where(author: user)
      else
        scope.where(published: true)
      end

    end
  end

  def create?
    authenticated?
  end

  def show?
    authenticated? && (user.admin? || owner_of?)
  end

  alias_method :update?, :show?

  alias_method :destroy?, :show?

  alias_method :publish?, :show?

  def owner_of?
    record.author == user
  end

  def authenticated?
    !user.nil?
  end

  def permitted_attributes
    if authenticated? && (user.admin? || owner_of?)
      [:term, :max_price, :ending_time, :ending_time_unit, :sort_by, :published]
    end
  end

end
