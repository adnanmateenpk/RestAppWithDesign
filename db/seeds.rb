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
	User.create(email: 'admin@restapp.com', password: 'adminpassword', :role_id => 1 , :name => "Super Admin")
	User.create(email: 'restaurant1@restapp.com', password: 'password', :role_id => 2 , :name => "Restaurant Owner 1")
	User.create(email: 'restaurant2@restapp.com', password: 'password', :role_id => 2 , :name => "Restaurant Owner 2")
	User.create(email: 'customer@restapp.com', password: 'password', :role_id => 3 , :name => "Customer")