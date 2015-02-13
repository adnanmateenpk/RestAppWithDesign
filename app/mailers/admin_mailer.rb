class AdminMailer < ApplicationMailer
	default from: "webshacktesting@gmail.com"

	def welcome_email(user)
	    @user = user
	    mail(to: @user.email, subject: 'Welcome to the Resturant App')
  	end
  	def membership_change_request(user)
	    @user = user
	    mail(to: ENV["GMAIL_USERNAME"], subject: 'Membership Change Request')
  	end
  	def cancel_reservation(user,code)
	    @reservation_code = code
	    mail(to: user.email, subject: 'Reservation Cancelled')
  	end
  	def create_customer_reservation(user,code,time)
	    @reservation_code = code
	    @time = time
	    mail(to: user.email, subject: 'Reservation Created')
  	end
  	def create_restaurant_reservation(restaurant,user,code,time)
	    @reservation_code = code
	    @time = time
	    @user = user
	    mail(to: restaurant.email, subject: 'Reservation Created')
  	end
end
