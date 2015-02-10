# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	ActiveRecord::Base.connection.execute("TRUNCATE layouts; ")
	Layout.create(:layout => "_gallery",:title => "Gallery")
	Layout.create(:layout => "_blog",:title => "Blog")
	Layout.create(:layout => "_contact",:title => "Contact")
	Layout.create(:layout => "_featured",:title => "Content with Fixed Image")
	Layout.create(:layout => "_reservations",:title => "Reservations")
	Layout.create(:layout => "_slider",:title => "Content with Slider")

	ActiveRecord::Base.connection.execute("TRUNCATE settings;")
	Setting.create(:title => "Restaurants App", :email => "test@test.com",:logo => "")

	ActiveRecord::Base.connection.execute("TRUNCATE roles; ")
	Role.create(:role => "admin" , :title => "Admin")
	Role.create(:role => "restaurant", :title => "Restaurant Owner")
	Role.create(:role => "user", :title => "Customer")

	User.destroy_all
	ActiveRecord::Base.connection.execute("TRUNCATE users;")
	User.create(email: 'admin@restapp.com', password: 'adminpassword', :role_id => 1 , :name => "Super Admin" ,:membership => Digest::SHA1.hexdigest('admin@restapp.com')[0,6] , :phone => "111-111-111") #super admin who can do everything like batman :P
	User.create(email: 'restaurant1@restapp.com', password: 'password', :role_id => 2 , :name => "Restaurant Owner 1",:membership => Digest::SHA1.hexdigest('restaurant1@restapp.com')[0,6], :phone => "111-111-111") # restaurant owner who can only add restaurants and manage them
	User.create(email: 'restaurant2@restapp.com', password: 'password', :role_id => 2 , :name => "Restaurant Owner 2",:membership => Digest::SHA1.hexdigest('restaurant2@restapp.com')[0,6], :phone => "111-111-111") # restaurant owner who can only add restaurants and manage them
	User.create(email: 'customer@restapp.com', password: 'password', :role_id => 3 , :name => "Customer",:membership => Digest::SHA1.hexdigest('customer@restapp.com')[0,6], :phone => "111-111-111") #customer who cant do anything except bookings

	ActiveRecord::Base.connection.execute("TRUNCATE restaurants;")
	Restaurant.create(:title=>"First",:slug => "first",:user_id => 2,:status => 1)
	Restaurant.create(:title=>"Second",:slug => "second",:user_id => 2,:status => 1)

	ActiveRecord::Base.connection.execute("TRUNCATE branches;")
	Branch.create(:title=>"First",:slug => "first", :position => 1 , :seating_capacity => 10 , :email => "first-branch@branch.com" , :expiry => "1",:user_id => 2 , :restaurant_id => 1 ,:status => 1 , :open => Time.parse("2001-01-01 12:00 PM") , :close => Time.parse("2001-01-02 12:00 AM"))
	Branch.create(:title=>"Second",:slug => "second", :position => 2 , :seating_capacity => 15 , :email => "second-branch@branch.com" , :expiry => "1",:user_id => 2 , :restaurant_id => 1 ,:status => 1 , :open => Time.parse("2001-01-01 12:00 PM"), :close => Time.parse("2001-01-02 12:00 AM"))
	Branch.create(:title=>"Third",:slug => "third", :position => 3 , :seating_capacity => 20 , :email => "third-branch@branch.com" , :expiry => "1",:user_id => 2 , :restaurant_id => 1 ,:status => 1, :open => Time.parse("2001-01-01 12:00 PM"), :close => Time.parse("2001-01-02 12:00 AM"))

	ActiveRecord::Base.connection.execute("TRUNCATE reservations;")