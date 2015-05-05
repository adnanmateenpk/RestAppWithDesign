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
  	#AdminMailer.membership_change_request(current_user).deliver_now
    flash[:notice]="You request has been generated !!"
  	redirect_to root_url
  end
  
  def restaurant
    Reservation.expire_reservations
    if !params[:time_zone].blank?
      Time.zone = params[:time_zone]
    end
    if !params[:date].blank?
      date = params[:date].split('/')
      params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    end
    if params[:date].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Date/Time"}
    elsif params[:time].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Date/Time"}
    elsif params[:customer].blank?
      render :json => {"available" => false, "message" => "Please enter a valid Email Address"}
    elsif params[:restaurant].blank?
      render :json => {"all_slots"=>true , "available" => false, "message" => "Please enter a valid membership code"}
    elsif params[:branch].blank?
      render :json => {"restaurant_slots" => true, "available" => false, "message" => "Availabale Time slots for all the branches for the Selected Restaurant are shown below", "time_slots" => get_restaurant_timeslots(Restaurant.find(params[:restaurant]))}
    elsif Time.zone.parse(params[:date]+" "+ params[:time]) <= Time.zone.now
      render :json => {"available" => false, "message" => "Please Enter A Valid Date/Time"}
    else
      branch = Branch.find(params[:branch])
       params[:customer] = Digest::SHA1.hexdigest(params[:customer])[0,6]
      slots = TimeSlot.where("branch_id = ? AND slot > ? AND slot > ? ",branch.id, Time.now.utc, params[:date])
      if check_branch_timings branch,params[:time]
        render :json => {"available" => false, "message" => "Branch is closed at the selected Date/Time"}
      elsif check_seats slots,branch,Time.zone.parse(params[:date]+" "+params[:time])
        render :json => {"branch_slots" => true, "available" => false, "message" => "Capacity breached at this time please select an available time in the below list","time_slots" => get_available_timeslots(slots,branch)}
      else 
        render :json => {"available" => true, "message" => "Creating Reservation"}
      end
    end

  end
  def reservations

    @reservations = Reservation.where("status = ? AND user_id = ? ",true ,current_user.membership)
    puts @reservations.count
  end
  def customer
    Reservation.expire_reservations
    if !params[:time_zone].blank?
      Time.zone = params[:time_zone]
    end
    if !params[:date].blank?
      date = params[:date].split('/')
      params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    end

    if params[:date].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Date/Time"}
    elsif params[:time].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Date/Time"}
    elsif params[:people].blank? 
      render :json => {"available" => false, "message" => "Please Enter A Valid Number of People"}  
    elsif params[:restaurant].blank?
      render :json => {"user_signed_in" => user_signed_in?,"all_slots"=>true , "available" => false, "message" => "Available Slots for all restaurants are listed below" , "time_slots" => get_all_timeslots}
    elsif params[:branch].blank?
      render :json => {"user_signed_in" => user_signed_in?,"restaurant_slots" => true, "available" => false, "message" => "Available Times For All The Branches Of Selected Restaurant", "time_slots" => get_restaurant_timeslots(Restaurant.find(params[:restaurant]))}
    elsif Time.zone.parse(params[:date]+" "+ params[:time]) <= Time.zone.now
      render :json => {"available" => false, "message" => "Please Enter A Valid Date/Time"}
    else
      branch = Branch.find(params[:branch])
      slot_time1 = Time.zone.parse(params[:date]+" "+branch.open.strftime("%H:%M:%S"))
      if  branch.open.strftime("%d").to_i < branch.close.strftime("%d").to_i
          slot_time2 = Time.zone.parse(params[:date]+" "+branch.close.strftime("%H:%M:%S")) + 24*60*60
      else 
          slot_time2 = Time.zone.parse(params[:date]+" "+branch.close.strftime("%H:%M:%S")) 
      end


      slots = TimeSlot.where("branch_id = ? AND slot > ? AND slot < ?",branch.id, slot_time1,slot_time2).order("id ASC")
      if check_branch_timings branch,params[:time]
        render :json => {"available" => false, "message" => "Branch is closed at the selected Date/Time"}
      elsif check_slot slots,branch,Time.zone.parse(params[:date]+" "+params[:time])
        render :json => {"user_signed_in" => user_signed_in?,"branch_slots" => true, "available" => false, "message" => "Capacity Breached Please Select An Available Time From The List","time_slots" => get_available_timeslots(slots,branch)}
      else 
        render :json => {"available" => true, "message" => "Creating Reservation" , "user_signed_in" => user_signed_in?,"time_zone" => params[:time]}
      end
    end
  end

  private 
  def check_seats values,branch,time
    Time.zone = branch.time_zone
    return_value = false
    values.each_with_index do |v,i|
      
      if v.slot == time 
        return_value = v.seats+params[:people].to_i > branch.seating_capacity
      end
      
    end
    return_value

  end
  def check_slot values,branch,time
    Time.zone = branch.time_zone
    return_value = false
    values.each_with_index do |v,i|
      
      if v.slot == time 
        
        return_value = v.seats+params[:people].to_i > branch.seating_capacity 
        if i < values.count
          return_value = values[i+1].seats+params[:people].to_i > branch.seating_capacity 
        end
      end
      
      break if return_value
      
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
    !(Time.zone.parse(branch.open.strftime("%Y-%m-%d") + " " + slot) >= branch.open && Time.zone.parse(branch.close.strftime("%Y-%m-%d") + " " + slot) < branch.close)
  end
  

  private 
  def get_available_timeslots slots,branch
    Time.zone = branch.time_zone
    return_value = Array.new  
    popped = false
    slots.each do |s|
      r = Hash.new
      r["available"] = !(check_seats slots,branch,s.slot)
      r["time_slot"] = s.slot.strftime("%I:%M:%S %p %Z")
      if r["available"] 
        return_value << r
      elsif !r["available"] and !popped
        return_value.pop
        popped=true
      end
    end
    return_value   
  end
  private 
  def get_restaurant_timeslots restaurant
    branches= restaurant.branches.published
    return_value = Array.new
    branches.each do |b|
      TimeSlot.initialize_slots params[:date],b.id
      slots = b.time_slots.where("slot > ?",params[:date])
      r = Hash.new
      r["id"] = b.id
      r["title"] = b.title
      r["time_slots"] = get_available_timeslots slots,b
      if r["time_slots"].count > 0
        return_value << r
      end
    end
    return_value

  end
  def get_all_timeslots 
    restaurants= Restaurant.published
    return_value = Array.new
    restaurants.each do |r|
      re = Hash.new
      re["title"] = r.title
      re["id"] = r.id
      re["time_slots"] = get_restaurant_timeslots r
      if re["time_slots"].count > 0
        return_value << re
      end
    end
    return_value

  end
  
end
