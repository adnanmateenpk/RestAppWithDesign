class TablesController < ApplicationController
  before_action :auth_user , :except => [:list]
  layout 'admin'
  authorize_resource :class => false
  def index
    @restaurant = Restaurant.where(["slug = ?",params[:restaurant_slug]]).first
  	@tables = @restaurant.tables
    @table = Table.new
     
  end

  def show
  end

  def edit
  end

  def new
  end

  def destroy
    table = Table.find(params[:id])
    table.destroy
    render json: { "gst" => "deleted" }
  end
  def create
    @table  = Table.new(table_params)
    if @table.save
      flash[:notice] = "Tables saved succesfully"
      redirect_to :action=>:index
    else
      flash[:error_model] =  @table.errors.full_messages
      redirect_to :action=>:index
    end
  end
  def update
  end

  private
  def table_params
    params.require(:table).permit(:seats,:quantity,:restaurant_id)
  end
end
