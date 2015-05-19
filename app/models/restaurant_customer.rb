class RestaurantCustomer < ActiveRecord::Base
	belongs_to :restaurant_owner , :foreign_key => :restaurant_owner_id , :class_name => "User" 
	belongs_to :user
end
