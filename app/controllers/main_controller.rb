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
    Reservation.expire_reservations
    results = check_availability

    if results[0]
      render :json => {"available" => results[0], "message" => results[1]}
    elsif !results[0] and results[1] == "Time Slot Not Available"
      render :json => {"available" => results[0], "message" => results[1]}
    else
      render :json => {"available" => results[0], "message" => results[1]}
    end

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
  def check_repeat value,time
    return_value = false
    if !value.blank?
     return_value = value.expire_at > time
    end  
    return_value
  end
  private 
  def check_branch_timings branch,slot
    !(Time.parse(branch.open.strftime("%Y-%m-%d") + " " + slot) > branch.open || Time.parse(branch.close.strftime("%Y-%m-%d") + " " + slot) < branch.close)
  end
  private 
  def check_availability
    available = true
    message = "Time slot available"
    already = false
    if !params[:date].blank?
      date = params[:date].split('-')
      params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    end
    branch = Branch.find(params[:branch])
    puts branch
    if params[:date].blank? or params[:time].blank?
      available = false
      message = "Please Enter A Valid Time"
    elsif Time.parse(params[:date]+" "+ params[:time]) <= Time.now
      available = false
      message = "Please Enter A Valid Time"
    elsif check_repeat Reservation.availability_for_restaurant(Time.parse(params[:date]+" "+params[:time]).strftime("%Y-%m-%d %H:%M"),params[:branch],params[:id]).sorted.where("user_id = ?",params[:customer]).first,Time.parse(params[:date]+" "+params[:time])
        available = false
        message = "Membership No. has a reservation clash"
    elsif params[:customer].blank?
      available = false
      message = "Please enter a valid membership code"
    elsif check_branch_timings branch,params[:time]
      available = false
      message = "Selected Branch opens at "+branch.open.strftime("%I:%M %p")+" uptill "+branch.close.strftime("%I:%M %p")
    else 
      old = Reservation.availability_for_restaurant(Time.parse(params[:date]+" "+params[:time]).strftime("%Y-%m-%d %H:%M"),params[:branch],params[:id]).sorted
      if check_seats old,params[:people].to_i,branch.seating_capacity
        available = false
        message = "Time Slot Not Available"
      
      end
    end
    [available,message]
  end
  
end
