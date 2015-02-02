class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
    	t.string :title
    	t.string :logo 
    	t.string :email
    	t.string :company_name
    	t.string :phone
    	t.string :fax
    	t.string :address
    	t.string :meta_keywords
    	t.text	 :meta_description
      	t.timestamps null: false
    end
  end
end
