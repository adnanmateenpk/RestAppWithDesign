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
    	t.integer :restaurant_id
      	t.timestamps null: false
    end
    
    add_index "branches" , "slug"
    add_index "branches" , "position"
    add_index "branches" , "restaurant_id"
  end
end
