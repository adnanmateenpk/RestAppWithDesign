class AlterReser < ActiveRecord::Migration
  def up
  	change_column "reservations","user_id",:string
  end
  def down
  	change_column "reservations","user_id",:integer
  end
end
