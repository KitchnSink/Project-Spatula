class FilterPolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.nil?
        scope.where(published: true)
      elsif user.admin?
        scope.all
      else
        if scope.first.user.id == user.id
          user.filters
        else
          scope.where(published: true)
        end
      end

    end
  end

  def create?
    authenticated?
  end

  def update?
    record.user.nil? || (authenticated? && (user.admin? || owner_of?))
  end

  alias_method :destroy?, :update?

  alias_method :publish?, :update?

  def owner_of?
    has_owner? && record.user.id == user.id
  end

  def has_owner?
    record.respond_to?('user')
  end

  def authenticated?
    !user.nil?
  end

  def permitted_attributes
    if authenticated? && (user.admin? || owner_of?)
      [:search_term, :max_price, :ending_time, :ending_time_unit, :sort_by, :published]
    else
      [:search_term, :max_price, :ending_time, :ending_time_unit, :sort_by]
    end
  end

end
