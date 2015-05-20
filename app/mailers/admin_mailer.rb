class AdminMailer < ApplicationMailer
	default from: "reservados2015@gmail.com"

	def welcome_email(user)
	    @user = user
	    mail(to: @user.email, subject: 'Welcome to the '+Setting.first.title)
  	end
  	def membership_change_request(user)
	    @user = user
	    mail(to: Setting.first.email, subject: 'Membership Change Request')
  	end
  	def contact_us(message,subject, from, name)
	    @message = message
	    @name = name
	    mail(to: Setting.first.email, subject: subject , from: name + "<" +from+">"  )
  	end
  	def cancel_reservation(user,code)
	    @reservation_code = code
	    mail(to: user.email, subject: 'Reservation Cancelled', from:  + "<" +from+">")
  	end
  	def success_reservation(user,code)
	    @reservation_code = code
	    mail(to: user.email, subject: 'Reservation Successful')
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
