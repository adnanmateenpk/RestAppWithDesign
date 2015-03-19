class AlterBranches < ActiveRecord::Migration
  def change
  	remove_column "branches","open"
  	add_column "branches","open",:datetime
  	remove_column "branches","close"
  	add_column "branches","close",:datetime
  end
  
end
