class AlterBranches < ActiveRecord::Migration
  def up
  	change_column "branches","open",:datetime
  	change_column "branches","close",:datetime
  end
  def down
  	change_column "branches","open",:time
  	change_column "branches","close",:time
  end
end
