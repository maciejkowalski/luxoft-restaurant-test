class AddRestaurantIdToTables < ActiveRecord::Migration
  def change
    add_column :tables, :restaurant_id, :integer
    add_index :tables, :restaurant_id
  end
end
