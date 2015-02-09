class MainController < ApplicationController
  def index
  
  end

  def subscription

  end

  def convert_user
  	current_user.role_id = 2
  	current_user.save
  	flash[:notice]="You can now add your own Restaurants"
  	redirect_to root_url
  end
  def restaurant
    available = false
    date = params[:date].split('-')
    params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    branch = Branch.find(params[:branch])
    old = Reservation.availability_for_restaurant(params["date"]+" "+params[:time],params[:branch]).sorted
    count = 0
    old.each do |o|
      count = count+o.people
    end
    available = count+params[:people].to_i <= branch.seating_capacity
     
    render :json => {"found" => available, "data" => count+params[:people].to_i}
  end
  def customer

  end
end
