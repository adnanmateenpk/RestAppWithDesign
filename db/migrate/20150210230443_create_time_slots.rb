class CreateTimeSlots < ActiveRecord::Migration
  def change
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
