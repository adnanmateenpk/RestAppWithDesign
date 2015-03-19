class AlterBranches < ActiveRecord::Migration
  def change
  	remove_column "branches","open", :time
  	add_column "branches","open",:datetime
  	remove_column "branches","close" , :time
  	add_column "branches","close",:datetime
  end
  
end
