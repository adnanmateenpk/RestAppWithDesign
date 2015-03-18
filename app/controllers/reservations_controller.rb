class ReservationsController < ApplicationController
  before_action :authenticate_user! 
  layout 'admin'
  authorize_resource :class => false
  skip_filter :verify_authenticity_token, :create
  def new
   
    @reservation = Reservation.new(:booking=>"7:30 PM")

    restaurants = Restaurant.by_user(current_user.id).published
    @restaurants = Array.new
    restaurants.each_with_index do |u,i|
      if u.branches.count > 0
        @restaurants[i] = Array.new
        @restaurants[i] = [u.title,u.id.to_s+"|"+u.slug]
      end  
    end
  end
  def create
    @reservation = Reservation.new(reservation_params)
    TimeSlot.initialize_slots @reservation.booking.strftime("%Y-%m-%d"),@reservation.branch_id
     
    if check_repeat Reservation.availability_for_restaurant(Time.zone.parse(params[:date]+" "+params[:time]).utc.strftime("%Y-%m-%d %H:%M"),params[:reservation][:branch_id],0).sorted.where("user_id = ?", params[:reservation][:user_id]).first,Time.zone.parse(params[:date]+" "+params[:time]).utc
       flash[:alert] = "Membership No. Conflict please select another time"
       restaurants = Restaurant.by_user(current_user.id).published
        @restaurants = Array.new
        restaurants.each_with_index do |u,i|
          @restaurants[i] = Array.new
          @restaurants[i] = [u.title,u.id.to_s+"|"+u.slug] 
        end
        @date = @reservation.booking.strftime("%m-%d-%Y")
        @time = @reservation.booking.strftime("%H:%M:%S")
        if user_signed_in? and current_user.role_id == 3
          redirect_to :action => :index,:controller => :main
        else
          render "new"
        end
    elsif @reservation.save 
      TimeSlot.adjust_people @reservation.booking,@reservation.branch.expiry*2, @reservation.people
      AdminMailer.create_customer_reservation(@reservation.user,@reservation.reservation_code,@reservation.booking).deliver_now
      AdminMailer.create_restaurant_reservation(@reservation.branch.restaurant.user, @reservation.user,@reservation.reservation_code,@reservation.booking).deliver_now
      flash[:notice] = "Reservation Created for '#{@reservation.user.name}' with Reservation Code #{@reservation.reservation_code}"
      if session[:customer]
        session[:customer] = false
        redirect_to :action => :index,:controller => :main
      else
        redirect_to :action => :index
      end
    else 
      restaurants = Restaurant.by_user(current_user.id).published
      @restaurants = Array.new
      restaurants.each_with_index do |u,i|
        @restaurants[i] = Array.new
        @restaurants[i] = [u.title,u.id.to_s+"|"+u.slug] 
      end
      @date = @reservation.booking.strftime("%m-%d-%Y")
      @time = @reservation.booking.strftime("%H:%M:%S")
      render "new"
    end
  end
  def edit
    @reservation = Reservation.where("reservation_code = ?",params[:reservation_code]).first
    @date = @reservation.booking.strftime("%m-%d-%Y")
    @time = @reservation.booking.strftime("%H:%M:%S")
  end
  def destroy
    reservation = Reservation.where("reservation_code = ?",params[:reservation_code]).first
    reservation.status = 0
    TimeSlot.adjust_people reservation.booking,reservation.branch.expiry*2, -1*reservation.people
    AdminMailer.cancel_reservation(reservation.user,reservation.reservation_code).deliver_now
    render :json => {"cancelled" => reservation.save}
  end
  def update 
    @reservation = Reservation.where("reservation_code = ?",params[:reservation_code]).first
    old = @reservation.people
    values=reservation_params
    if check_repeat Reservation.availability_for_restaurant(Time.zone.parse(params[:date]+" "+params[:time]).utc.strftime("%Y-%m-%d %H:%M"),params[:reservation][:branch_id],0).sorted.where("user_id = ?", params[:reservation][:user_id]).first,Time.zone.parse(params[:date]+" "+params[:time]).utc
       flash[:alert] = "Membership No. Conflict please select another time"
       restaurants = Restaurant.by_user(current_user.id).published
        @restaurants = Array.new
        restaurants.each_with_index do |u,i|
          @restaurants[i] = Array.new
          @restaurants[i] = [u.title,u.id.to_s+"|"+u.slug] 
        end
        @date = @reservation.booking.strftime("%m-%d-%Y")
        @time = @reservation.booking.strftime("%H:%M:%S")
        render "edit"
    elsif @reservation.update_attributes(values) 
      TimeSlot.adjust_people @reservation.booking,@reservation.branch.expiry*2, @reservation.people - old
      flash[:notice] = "Reservation Updated for '#{@reservation.user.name}' with Reservation Code #{@reservation.reservation_code}"
      redirect_to :action => :index
    else 
      @date = @reservation.booking.strftime("%m-%d-%Y")
      @time = @reservation.booking.strftime("%H:%M:%S")
      render "edit"
    end
  end
  def index
  	if current_user.role_id == 1 
  		@reservations = Reservation.sorted
  	else
  		@reservations = Reservation.by_restaurant_owner(current_user.id).sorted
  	end
  end
  def filtered
    if !params[:search].blank?
        render "index"
    else
        redirect_to ({:action=>:index}) 
    end
  end
  private
  def reservation_params
    Time.zone = params[:time_zone]
    params[:reservation][:status] = params[:reservation][:status].blank? ? 1 : params[:reservation][:status]
    date = params[:date].split('/')
    params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    params[:reservation][:booking] = Time.zone.parse(params[:date]+ " " + params[:time])
    params[:reservation][:expire_at] = params[:reservation][:booking] + Branch.find(params[:reservation][:branch_id]).expiry*60*60
    params[:reservation][:reservation_code] = Digest::SHA1.hexdigest(Time.zone.now.to_s)[0,6]
    if params[:reservation][:reservation_name].blank?
      params[:reservation][:reservation_name] = params[:reservation][:reservation_code]
    end
    params[:reservation][:created_by] = current_user.id;
    if session[:customer]
      params[:reservation][:user_id] = Digest::SHA1.hexdigest(current_user.email)[0,6]
      params[:reservation][:reservation_name] = current_user.name

    else
      params[:reservation][:user_id] = Digest::SHA1.hexdigest(params[:reservation][:user_id])[0,6]
    end
    params[:reservation][:restaurant_owner] = Branch.find(params[:reservation][:branch_id]).user_id;
    params.require(:reservation).permit(:reservation_name,:reservation_code,:booking,:expire_at, :people ,:user_id, :status, :branch_id,:created_by,:restaurant_owner)
  end
  private 
  def check_repeat value,time
    return_value = false
    if !value.blank?
     return_value = value.expire_at > time
    end  
    return_value
  end
end
