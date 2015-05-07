class ReservationsController < ApplicationController
  before_action :auth_user
  layout 'admin'
  authorize_resource :class => false
  skip_filter :verify_authenticity_token, :create
  def new
    redirect_to :controller=>:main , :action => :index
  end
  def create
    @reservation = Reservation.new(reservation_params)
    flash[:notice] = "Site Down For Maintainence"
    redirect_to :action => :index,:controller => :main
   
  end
  def edit
   
  end
  def destroy
    reservation = Reservation.where("reservation_code = ?",params[:reservation_code]).first
    reservation.status = 0
    TimeSlot.adjust_people reservation.booking,reservation.branch.expiry*2, -1*reservation.people
    AdminMailer.cancel_reservation(reservation.user,reservation.reservation_code).deliver_now
    reservation.save
    redirect_to :controller=>:main , :action => :reservations
  end
  def update 
    
  end
  def index
  	redirect_to :controller=>:restaurants , :action => :index
  end
  def list
    
    @reservations  = Reservation.where("branch_id = ?" , params[:id])

    render 'index'
   # redirect_to  :action => :index
  end
  def filtered_list
    Time.zone = Branch.find(params[:id]).time_zone
    date = params[:date].split('/')
    params[:date] = date[2]+"-"+date[0]+"-"+date[1]
    startTime = Time.zone.parse(params[:date]).utc
    endTime = Time.zone.parse(params[:date]).utc + 24*60*60
    @reservations  = Reservation.where("branch_id = ? AND booking < ? AND booking >= ? " , params[:id],endTime,startTime )
    render 'index'
  end
  def show
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
    params[:reservation][:created_by] = current_user.id;
    params[:reservation][:user_id] = Digest::SHA1.hexdigest(current_user.email)[0,6]
    params[:reservation][:reservation_name] = current_user.name
    params[:reservation][:restaurant_owner] = Branch.find(params[:reservation][:branch_id]).user_id;
    params.require(:reservation).permit(:reservation_name,:reservation_code,:booking,:expire_at, :people ,:user_id, :status, :branch_id,:created_by,:restaurant_owner)
  end

  
end
