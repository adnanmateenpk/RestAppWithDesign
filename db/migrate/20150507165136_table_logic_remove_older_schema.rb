class TableLogicRemoveOlderSchema < ActiveRecord::Migration
  def up
  	drop_table :time_slots
  	remove_column :reservations, :status, :boolean
  	add_column :reservations, :status, :integer
  end
  def down
  	remove_column :reservations, :status, :integer
  	add_column :reservations, :status, :boolean
  	
  	create_table :time_slots do |t|
    	t.datetime :slot
    	t.integer :seats
    	t.integer :branch_id
      t.timestamps null: false
    end
    add_index :time_slots, :slot
    add_index :time_slots, :branch_id

  end
 
end
