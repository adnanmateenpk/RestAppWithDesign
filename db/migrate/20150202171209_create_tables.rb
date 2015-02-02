class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
    	t.string :title
    	t.string :slug
    	t.integer :chairs
    	t.integer :branch_id
    	t.string :featured_image
    	t.integer :position
      	t.timestamps null: false
    end
    add_index "tables" , "slug"
    add_index "tables" , "position"
    add_index "tables" , "branch_id"
  end
end
