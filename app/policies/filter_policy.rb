class FilterPolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      unless !user.nil?
        user.filters
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
    has_owner? && record.user == user
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
