class CreateIps < ActiveRecord::Migration
  def change
    create_table :ips do |t|
    	t.string :address
    	t.integer :visits
      	t.timestamps null: false
    end
    add_index "ips" , "visits"
  end
end
