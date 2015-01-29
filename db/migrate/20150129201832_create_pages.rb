class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    	t.string 	:title
    	t.string 	:slug
    	t.text 		:html
    	t.integer 	:layout_id
    	t.string 	:featured_image
        t.integer   :position
    	t.boolean	:status
    	t.string	:meta_keywords
    	t.string 	:meta_description
    	t.timestamps null: false
    end
  end
end
