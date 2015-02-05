class AlterTableBranches < ActiveRecord::Migration
  def change
  	add_column "branches", "user_id" , :integer
  	add_column "tables", "user_id" , :integer
  end
end
