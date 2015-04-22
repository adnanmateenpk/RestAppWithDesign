class AlterBranch < ActiveRecord::Migration
  def change
  	add_column "branches","night_club", :boolean
  end
end
