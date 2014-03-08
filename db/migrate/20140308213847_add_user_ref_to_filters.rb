class AddUserRefToFilters < ActiveRecord::Migration
  def change
    add_reference :filters, :user, index: true
  end
end
