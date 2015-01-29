# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	
	Layout.create(:layout => "_gallery")
	Layout.create(:layout => "_blog")
	Layout.create(:layout => "_contact")
	Layout.create(:layout => "_featured")
	Layout.create(:layout => "_slider")

