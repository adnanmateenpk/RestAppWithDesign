class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
    	t.string :title
    	t.string :slug
    	t.string :address
    	t.string :phone
    	t.string :fax
    	t.string :email
    	t.string :featured_image
    	t.integer :position
        t.boolean :status
        t.time :open
        t.time :close
        t.integer :seating_capacity
        t.integer :expiry
    	t.integer :restaurant_id
        t.integer :user_id
      	t.timestamps null: false
    end
    
    add_index "branches" , "slug"
    add_index "branches" , "position"
    add_index "branches" , "restaurant_id"
    add_index "branches" , "open"
    add_index "branches" , "close"
    add_index :branches , :user_id

  end
end
