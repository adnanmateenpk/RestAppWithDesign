class CreateReservationTables < ActiveRecord::Migration
  def change
    create_table :reservation_tables do |t|
    	t.integer :table_id
    	t.integer :reservation_id
    	t.datetime :booking
    	t.timestamps null: false
    end
    add_index :reservation_tables, :table_id
    add_index :reservation_tables, :reservation_id
    add_index :tables, :restaurant_id
    add_index :tables, :seats
  end
end
