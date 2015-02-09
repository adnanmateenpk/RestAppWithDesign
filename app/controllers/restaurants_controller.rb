class RestaurantsController < ApplicationController
  before_action :authenticate_user! , :except => [:list]
  layout 'admin'
  authorize_resource :class => false
 def index
    if current_user.role_id != 1
      @restaurants = Restaurant.where(["user_id = ?",current_user.id])
    else
      @restaurants = Restaurant.all
    end
  	
  end
def list
    render json: Restaurant.published
end
  def edit
    if current_user.role_id == 1
      @restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
     
      @users = User.where(["role_id = ?",2])

        
    else
       @restaurant = Restaurant.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    end
  end

  def new
    @restaurant = Restaurant.new
    if current_user.role_id == 1
        @users = User.where(["role_id = ?",2])

        
      end
  end
  
  def create
    @restaurant = Restaurant.new(restaurant_params("test"))
    
    if @restaurant.save
      flash[:notice] = "Restaurant saved"
      redirect_to(:action=>'index')
    else
      if current_user.role_id == 1
        @users = User.where(["role_id = ?",2])

        
      end
      render("new")
    end

  end

  def destroy
    if current_user.role_id != 1
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
  	if current_user.role_id != 1
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
    if current_user.role_id != 1
      @restaurant = Restaurant.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    else
      @restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    end
    if @restaurant.update_attributes(restaurant_params(@restaurant.featured_image))
      flash[:notice] = "Restaurant saved"
      redirect_to(:action=>'index')
    else
      if current_user.role_id == 1
        @users = User.where(["role_id = ?",2])

        
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
       params[:restaurant][:slug] = (current_user.membership+" "+params[:restaurant][:title]).parameterize
    else
        params[:restaurant][:slug] = params[:restaurant][:slug].parameterize
    end
    if current_user.role_id == 2
      params[:restaurant][:user_id] = current_user.id 
    end
    params.require(:restaurant).permit(:title,:slug,:status,:description,:featured_image,:user_id)
  end
end
