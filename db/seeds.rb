# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	ActiveRecord::Base.connection.execute("TRUNCATE TABLE reservations RESTART IDENTITY;")
	ActiveRecord::Base.connection.execute("TRUNCATE TABLE reservation_tables RESTART IDENTITY;")
	ActiveRecord::Base.connection.execute("TRUNCATE TABLE restaurant_customers RESTART IDENTITY;")