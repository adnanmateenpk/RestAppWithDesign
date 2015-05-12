class MainController < ApplicationController

   before_action :auth_user, :only => [:reservations]
  @@table
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

    @reservations = Reservation.where("status = ? AND user_id = ? ",1 ,current_user.membership)
    
  end
  def customer
    if params[:restaurant].blank? or params[:branch].blank?
      render :json => {"available" => false, "message" => "Please Select a Restaurant"}
    elsif params[:date].blank?
      render :json => {"available" => false, "message" => "Please Enter a Valid Date"}
    elsif params[:time].blank?
      render :json => {"available" => false, "message" => "Please Enter a Valid Time"}
    elsif params[:people].blank?
      render :json => {"available" => false, "message" => "Please Enter Amount of people"}
    else
      Time.zone = params[:time_zone]
      date = params[:date].split('/')
      params[:date] = date[2]+"-"+date[0]+"-"+date[1]
      branch = Branch.find(params[:branch])
      if Time.zone.parse(params[:date]+" "+params[:time]).utc < Time.now.utc
        render :json => {"available" => false, "message" => "Booking Time cannot be in the past"}
      elsif check_times branch
        render :json => {"available" => false, "message" => "Restaurant is closed at the selected time"}
      elsif check_tables  
        render :json => {"available" => false, "message" => "There are no Tables available at the selected time. Please Call on : "+branch.phone+" for further assitence"}
      else
        render :json => {"user_signed_in" => user_signed_in? ,"available" => true, "message" => "Creating Resevation", "table" => @@table}
      end
    end
  end
  private 
  def check_tables 
    Time.zone = params[:time_zone]
    booking_time = Time.zone.parse(params[:date]+" "+params[:time]).utc
    tables = Table.reservation_tables_check params[:people].to_i, params[:people].to_i + 2,params[:restaurant]
    return_value = true
    tables.each do |t|
      if !(ReservationTable.where("table_id = ? AND booking = ?",t.id,booking_time).length >= t.quantity)
        return_value = false
        @@table = t.id
        break
      end

    end
    return_value
  end
  private
  def check_times branch
    Time.zone = params[:time_zone]
    !(Time.zone.parse(branch.open.strftime("%Y-%m-%d") + " " + params[:time]) >= branch.open && Time.zone.parse(branch.close.strftime("%Y-%m-%d") + " " + params[:time]) < branch.close)
  end

end
