class MainController < ApplicationController
   before_action :auth_user, :only => [:reservations]
  def index
    @reservation = Reservation.new(:booking=>"7:30 PM")

    @restaurants = Restaurant.published
    
  end
  def register
    flash[:register] = true
    redirect_to :action => :index
  end
  def subscription

  end
  def get_token

  end
  
  def convert_user
  	AdminMailer.membership_change_request(current_user).deliver_now
    flash[:notice]="You request has been generated !!"
  	redirect_to root_url
  end
  
  def restaurant
   

  end
  def reservations

    @reservations = Reservation.where("status = ? AND user_id = ? ",true ,current_user.membership)
    puts @reservations.count
  end
  def customer
    
  end

end
