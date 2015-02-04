class AlterTables < ActiveRecord::Migration
  def change
  		add_column "tables", "hours" , :float
  end
end
