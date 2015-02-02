class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
    	t.string :title
    	t.string :slug
    	t.string :featured_image
    	t.integer :user_id
    	t.text 	 :description
      	t.timestamps null: false
    end
    add_index "restaurants", "slug"
  end
end
