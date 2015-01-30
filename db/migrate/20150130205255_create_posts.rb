class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string 	:title
    	t.string 	:slug
    	t.text 		:html
    	t.string 	:featured_image
      t.integer :position
    	t.boolean	:status
    	t.string	:meta_keywords
    	t.string 	:meta_description

      t.timestamps null: false
    end
    add_index("posts","slug")
    add_index("posts","position")
    add_index("posts","status")
    add_index("pages","status")
  end
end
