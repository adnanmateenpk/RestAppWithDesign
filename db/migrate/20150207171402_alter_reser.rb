class AlterReser < ActiveRecord::Migration
  def change
  	remove_column "reservations","user_id",:integer
  	add_column "reservations","user_id",:string
  end
  
end
