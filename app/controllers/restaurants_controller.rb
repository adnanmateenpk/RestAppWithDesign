class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
 def index
    if current_user.role.role != "admin"
      @restaurants = Restaurant.where(["user_id = ?",current_user.id]).first
    else
      @restaurants = Restaurant.all
    end
  	
  end

  def edit
    if current_user.role.role != "admin"
      @restaurant = Restaurant.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
      users = User.where(["role_id = ?",1])

        @users = Array.new
        users.each_with_index do |u,i|
          @users[i] = Array.new
          @users[i] = [u.title,u.id] 
        end
    else
      @restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    end
  end

  def new
    @restaurant = Restaurant.new
    if current_user.role.role != "admin"
        users = User.where(["role_id = ?",1])

        @users = Array.new
        users.each_with_index do |u,i|
          @users[i] = Array.new
          @users[i] = [u.title,u.id] 
        end
      end
  end
  
  def create
    @restaurant = Restaurant.new(restaurant_params("test"))
    
    if @restaurant.save
      flash[:notice] = "Restaurant saved"
      redirect_to(:action=>'index')
    else
      if current_user.role.role != "admin"
        users = User.where(["role_id = ?",1])

        @users = Array.new
        users.each_with_index do |u,i|
          @users[i] = Array.new
          @users[i] = [u.title,u.id] 
        end
      end
      render("new")
    end

  end

  def destroy
    if current_user.role.role != "admin"
      restaurant = Restaurant.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    else
      restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    end
    directory = File.join("vendor","assets","images","uploads","restaurants")
    if restaurant.featured_image.blank?
      restaurant.featured_image = "test"
    end
    old_path = File.join(directory,restaurant.featured_image)
    
    File.delete(old_path) if File.exist?(old_path)
    restaurant.destroy
    render json: { "gst": "deleted" } 
  end

  def remove_image
  	if current_user.role.role != "admin"
      restaurant = Restaurant.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    else
      restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    end
    directory = File.join("vendor","assets","images","uploads","restaurants")
    old_path = File.join(directory,restaurant.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    restaurant.featured_image = ""
    restaurant.save
    render json: { "gst": "deleted" } 
  end

  def update
    if current_user.role.role != "admin"
      @restaurant = Restaurant.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    else
      @restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    end
    if @restaurant.update_attributes(restaurant_params(@restaurant.featured_image))
      flash[:notice] = "Restaurant saved"
      redirect_to(:action=>'index')
    else
      if current_user.role.role != "admin"
        users = User.where(["role_id = ?",1])

        @users = Array.new
        users.each_with_index do |u,i|
          @users[i] = Array.new
          @users[i] = [u.title,u.id] 
        end
      end
      render("new")
    end
  end

  private
  def restaurant_params(old_image)
    if old_image.blank?
      old_image = "test"
    end
    if !params[:restaurant][:featured_image].blank?
      params[:restaurant][:featured_image]= upload_files_custom(params[:restaurant][:featured_image],"restaurants",old_image)
    end
    if params[:restaurant][:slug].blank?
       params[:restaurant][:slug] = params[:restaurant][:title].parameterize
    else
        params[:restaurant][:slug] = params[:restaurant][:slug].parameterize
    end
    if current_user.role.role == "restaurant"
      params[:restaurant][:user_id] = current_user.id 
    end
    params.require(:restaurant).permit(:title,:slug,:status,:description,:featured_image,:user_id)
  end
end
