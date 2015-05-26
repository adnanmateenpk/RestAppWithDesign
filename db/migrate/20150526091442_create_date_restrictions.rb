class CreateDateRestrictions < ActiveRecord::Migration
  def change
    create_table :date_restrictions do |t|
    	t.integer :restaurant_id
    	t.date :restricted_date
      t.timestamps null: false
    end
    add_index :date_restrictions, :restaurant_id
  end
end
