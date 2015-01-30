class AlterLayout < ActiveRecord::Migration
  def change
  	add_column("layouts","title", :string)
    add_index("pages","position")
    add_index("pages","layout_id")
  end
end
