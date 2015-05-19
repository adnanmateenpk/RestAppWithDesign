class CreateRestaurantCustomers < ActiveRecord::Migration
  def change
    create_table :restaurant_customers do |t|
    	t.integer :restaurant_owner_id
    	t.integer :user_id
      t.timestamps null: false
    end
    add_index :restaurant_customers, :restaurant_owner_id
    add_index :restaurant_customers, :user_id
  end
end
