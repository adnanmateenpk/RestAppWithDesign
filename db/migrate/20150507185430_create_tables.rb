class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
		t.integer :restaurant_id
    	t.integer :seats
    	t.integer :quantity
    	
      t.timestamps null: false
    end
  end
end
