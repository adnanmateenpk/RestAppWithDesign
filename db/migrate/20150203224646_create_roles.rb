class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
    	t.string :role
      	t.string :title
    end
  end
end
