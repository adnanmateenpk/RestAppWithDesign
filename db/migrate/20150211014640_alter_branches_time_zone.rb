class AlterBranchesTimeZone < ActiveRecord::Migration
  def change
  	add_column "branches","time_zone", :string
  	add_column "users","time_zone", :string
  	add_column "reservations","restaurant_owner",:integer
  end
end
