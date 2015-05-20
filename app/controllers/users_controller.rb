class UsersController < ApplicationController
  before_action :auth_user
  layout 'admin'
  authorize_resource :class => false
  def index
  	if current_user.role_id == 1
      if params[:role].blank?
  		  @users = User.without_current(current_user.id)
      else
        @users = User.without_current(current_user.id).where("role_id = ?", params[:role])
      end
  	else 
  		@users = current_user.customers
  	end
  end
  def filtered
  	if !params[:search].blank?
	  	if current_user.role_id == 1
	  		@users = User.without_current(current_user.id).search(params[:search])
	  	else 
	  		@users = User.without_current(current_user.id).limited_users.search(params[:search])
	  	end
	  	render "index"
	else
	  	redirect_to ({:action=>:index}) 
	end
  end
  def update
  	user= User.where("membership = ?",params[:membership]).first
  	user.role_id = params[:role_id]
  	user.save
  	render json: ["complete"]
  end
  def destroy
    user = User.where("membership = ?",params[:membership]).first
    user.destroy
    render json: { "gst" => "deleted" }
  end
  def show
  end
end
