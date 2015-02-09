class AlterReser2 < ActiveRecord::Migration
  def change
  	add_column "reservations","created_by",:integer
  	add_index "reservations", "created_by"
  end
end
