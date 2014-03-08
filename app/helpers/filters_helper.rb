module FiltersHelper

  def publish? filter
    policy(filter).publish?
  end

  def update? filter
    policy(filter).update?
  end

  def destroy? filter
    policy(filter).update?
  end

end
