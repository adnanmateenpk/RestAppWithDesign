# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	Layout.delete_all
	Layout.create(:layout => "_gallery",:title => "Gallery")
	Layout.create(:layout => "_blog",:title => "Blog")
	Layout.create(:layout => "_contact",:title => "Contact")
	Layout.create(:layout => "_featured",:title => "Content with Fixed Image")
	Layout.create(:layout => "_reservations",:title => "Reservations")
	Layout.create(:layout => "_slider",:title => "Content with Slider")
