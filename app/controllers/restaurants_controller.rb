class RestaurantsController < ApplicationController
  def index
  	@restaurants = Restaurant.all
  end

  def edit
    @restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
  end

  def new
    @restaurant = Restaurant.new
  end
  
  def create
    @restaurant = Restaurant.new(restaurant_params("test"))
    if @restaurant.save
      flash[:notice] = "Restaurant saved"
      redirect_to(:action=>'index')
    else
      render("new")
    end

  end

  def destroy
    restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    directory = File.join("vendor","assets","images","uploads","restaurants")
    old_path = File.join(directory,restaurant.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    restaurant.destroy
    render json: { "gst": "deleted" } 
  end

  def remove_image
  	restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    directory = File.join("vendor","assets","images","uploads","restaurants")
    old_path = File.join(directory,restaurant.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    restaurant.featured_image = ""
    restaurant.save
    render json: { "gst": "deleted" } 
  end

  def update
    @restaurant = Restaurant.where(["slug = ?",params[:slug]]).first
    if @restaurant.update_attributes(restaurant_params(@restaurant.featured_image))
      flash[:notice] = "Restaurant saved"
      redirect_to(:action=>'index')
    else
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
    params.require(:restaurant).permit(:title,:slug,:status,:description,:featured_image)
  end
end
