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
    if !params[:time_zone].blank?
      Time.zone = params[:time_zone]
    end
    if !params[:date].blank?
      date = params[:date].split('-')
      params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    end
    if params[:date].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Date"}
    elsif params[:time].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Time"}
    elsif params[:customer].blank?
      render :json => {"available" => false, "message" => "Please enter a valid membership code"}
    elsif params[:branch].blank?
      render :json => {"restaurant_slots" => true, "available" => false, "message" => "Availabale Time slots for all the branches for the Selected Restaurant are shown below", "time_slots" => get_restaurant_timeslots(params[:restaurant])}
    elsif Time.zone.parse(params[:date]+" "+ params[:time]) <= Time.zone.now
      render :json => {"available" => false, "message" => "Please Enter A Valid Time"}
    else
      branch = Branch.find(params[:branch])
      slots = TimeSlot.where("branch_id = ? AND slot LIKE ? ",branch.id, "%"+params[:date]+"%")
      if check_branch_timings branch,params[:time]
        render :json => {"available" => false, "message" => "Branch is closed at the selected Time"}
      elsif check_seats slots,branch,Time.zone.parse(params[:date]+" "+params[:time])
        render :json => {"branch_slots" => true, "available" => false, "message" => "Capacity breached at this time please select an available time in the below list","time_slots" => get_available_timeslots(slots,branch)}
      elsif check_repeat Reservation.availability_for_restaurant(Time.zone.parse(params[:date]+" "+params[:time]).utc.strftime("%Y-%m-%d %H:%M"),params[:branch],params[:id]).sorted.where("user_id = ?",params[:customer]).first,Time.zone.parse(params[:date]+" "+params[:time]).utc
        render :json => {"branch_slots" => true, "available" => false, "message" => "Membership No. Conflict please select another time"}
      else 
        render :json => {"available" => false, "message" => "Creating Reservation"}
      end
    end

  end
  def customer

  end

  private 
  def check_seats values,branch,time
    Time.zone = branch.time_zone
    return_value = false
    values.each do |v|
      if v.slot >= time and v.slot < time + branch.expiry*60*60
        return_value = v.seats+params[:people].to_i > branch.seating_capacity
      end
    end
    return_value

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
    Time.zone = params[:time_zone]
    !(Time.zone.parse(branch.open.strftime("%Y-%m-%d") + " " + slot) >= branch.open || Time.zone.parse(branch.close.strftime("%Y-%m-%d") + " " + slot) < branch.close)
  end
  

  private 
  def get_available_timeslots slots,branch
    Time.zone = branch.time_zone
    return_value = Array.new  
    slots.each do |s|
      r = Hash.new
      r["available"] = !(check_seats slots,branch,s.slot)
      r["time_slot"] = s.slot.strftime("%I:%M:%S %p %Z")
      return_value << r
    end
    return_value   
  end
  private 
  def get_restaurant_timeslots restaurant
    branches= Restaurant.find(restaurant).branches
    return_value = Array.new
    branches.each do |b|
      TimeSlot.initialize_slots params[:date],b.id
      slots = b.time_slots.where("slot LIKE ?","%"+params[:date]+"%")
      r = Hash.new
      r["title"] = b.title
      r["time_slots"] = get_available_timeslots slots,b
      return_value << r
    end
    return_value

  end
  
end
