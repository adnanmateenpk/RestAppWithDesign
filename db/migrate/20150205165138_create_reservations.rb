class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
        t.string :reservation_name
    	t.string :reservation_code
    	t.boolean :status
        t.integer :branch_id
    	t.integer :user_id
    	t.integer :people
    	t.datetime :booking
      t.timestamps null: false
    end
    add_index :reservations , :status
    add_index :reservations, :user_id
    add_index :reservations, :branch_id
    add_index :reservations, :booking
    
    
  end
end
