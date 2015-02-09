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
    available = true
    already = false
    date = params[:date].split('-')
    params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    branch = Branch.find(params[:branch])
    if(params[:customer].blank?)
      available = false
      message = "Please enter a valid membership code"
    elsif check_branch_timings branch,params[:time]
      available = false
      message = "Selected Branch opens at "+branch.open.strftime("%I:%M %p")+" uptill "+branch.close.strftime("%I:%M %p")
    else 
      old = Reservation.availability_for_restaurant(params[:date]+" "+params[:time],params[:branch],params[:id]).sorted
      if check_seats old,params[:people].to_i,branch.seating_capacity
        available = false
        message = "Seating Capacity breached"
      elsif check_repeat old,params[:customer]
        available = false
        message = "Membership No. has a reservation clash"
      end
    end
    render :json => {"found" => available, "message" => message}
  end
  def customer

  end

  private 
  def check_seats values,want,capacity
    count = 0
    values.each do |o|
      count = count+o.people
    end
    count+want > capacity

  end

  private 
  def check_repeat values,user
    return_value = false
    values.each do |o|
      if o.user_id == user
        return_value = true         
      end 
    end
    return_value
  end
  private 
  def check_branch_timings branch,slot
    !(Time.parse(branch.open.strftime("%Y-%m-%d") + " " + slot) > branch.open || Time.parse(branch.close.strftime("%Y-%m-%d") + " " + slot) < branch.close)
  end
end
