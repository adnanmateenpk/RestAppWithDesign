class ReservationsController < ApplicationController
  before_action :authenticate_user! 
  layout 'admin'
  authorize_resource :class => false
  def new
   
    @reservation = Reservation.new(:booking=>"7:30 PM")

    restaurants = Restaurant.by_user(current_user.id).published
    @restaurants = Array.new
    
    restaurants.each_with_index do |u,i|
      @restaurants[i] = Array.new
      @restaurants[i] = [u.title,u.id.to_s+"|"+u.slug] 
    end
  end
  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save 
      flash[:notice] = "Reservation Created With for '#{@reservation.user.name}' with Reservation Code #{@reservation.reservation_code}"
      redirect_to :action => :index
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
    @reservation = Reservation.where("reservation_code = ?",params[:reservation_code]).first
    @reservation.status = 0
    
    render :json => {"cancelled" => @reservation.save}
  end
  def update 
    @reservation = Reservation.where("reservation_code = ?",params[:reservation_code]).first
    if @reservation.update_attributes(reservation_params) 
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
  		@reservations = Reservation.by_creator(current_user.id).sorted
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
    params[:time] = params[:hours]+":"+params[:mins]+" "+params[:meri]
    params[:reservation][:status] = params[:reservation][:status].blank? ? 1 : params[:reservation][:status]
    date = params[:date].split('-')
    params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    params[:reservation][:booking] = params[:date]+ " " + params[:time]
    params[:reservation][:expire_at] = Time.at(Time.parse(params[:reservation][:booking]).to_i + Branch.find(params[:reservation][:branch_id]).expiry*60*60).strftime("%Y-%m-%d %H:%M")
    params[:reservation][:reservation_code] = Digest::SHA1.hexdigest(Time.now.to_s)[0,6]
    if params[:reservation][:reservation_name].blank?
      params[:reservation][:reservation_name] = User.where(["membership = ?", params[:reservation][:user_id]]).first.name
    end
    params[:reservation][:created_by] = current_user.id;
    params.require(:reservation).permit(:reservation_name,:reservation_code,:booking,:expire_at, :people ,:user_id, :status, :branch_id,:created_by)
  end
end
