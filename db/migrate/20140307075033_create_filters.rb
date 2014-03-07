class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :term
      t.integer :max_price
      t.integer :ending_time
      t.string :ending_time_unit
      t.string :sort_by
      t.boolean :published

      t.timestamps
    end
  end
end
