class Alter < ActiveRecord::Migration
  def up
  	change_column "users","role_id", :integer
  end
  def down
  	change_column "users","role_id", :string
  end
end
