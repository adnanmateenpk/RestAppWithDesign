class RestrictionsController < ApplicationController
	before_action :auth_user 
	layout 'admin'
	authorize_resource :class => false
	def index
		@restaurant = Restaurant.find(params[:id])
		@restrictions = @restaurant.date_restrictions

		 @restriction = DateRestriction.new
	end

	def create
		@restriction = DateRestriction.new(restriction_params)
	    if @restriction.save
	      flash[:notice] = "Date restriction saved succesfully"
	      redirect_to :action=>:index, :id => @restriction.restaurant_id
	    else
	      flash[:error_model] =  @restriction.errors.full_messages
	      redirect_to :action=>:index, :id => @restriction.restaurant_id
	    end
	end

	def destroy
		restriction = DateRestriction.find(params[:id])
	    restriction.destroy
	    render json: { "gst" => "deleted" }
	end
	private
	  def restriction_params
	  	date = params[:date_restriction][:restricted_date].split('/')
    	params[:date_restriction][:restricted_date] = date[2]+"-"+date[0]+"-"+date[1] + " 00:00"
	    params.require(:date_restriction).permit(:restricted_date,:restaurant_id)
	  end

end
