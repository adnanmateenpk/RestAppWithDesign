class TablesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  authorize_resource :class => false
  def index
    if current_user.role_id == 1
      @tables = Table.where(["branch_id = ?",Branch.where(["slug = ?",params[:branch_slug]]).first.id]).all
    else
      @tables = Table.where(["branch_id = ? AND user_id = ?",Branch.where(["slug = ?",params[:branch_slug]]).first.id,current_user.id]).sorted
    end
  end

  def edit
    @table_count = Table.count
    if current_user.role_id == 1
      @table = Table.where(["slug = ?",params[:slug]]).first
    else
      @table = Table.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    end
    
  end

  def new
    @table_count = Table.count + 1
    @table = Table.new
  end
  
  def create
    @table_count = Table.count + 1
    @table = Table.new(table_params("test"))
    branch =  Branch.where(["slug = ?",params[:branch_slug]]).first
    @table.branch_id = branch.id 
    @table.user_id = branch.user_id
    if @table.save
      flash[:notice] = "Table saved"
      redirect_to(:action=>'index')
    else
      render("new")
    end

  end

  def destroy
    if current_user.role_id == 1
      table = Table.where(["slug = ?",params[:slug]]).first
    else
      table = Table.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    end
    
    directory = File.join("vendor","assets","images","uploads","tables")
    if table.featured_image.blank?
      table.featured_image = "test"
    end
    old_path = File.join(directory,table.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    table.destroy
    render json: { "gst": "deleted" } 
  end

  def remove_image
    if current_user.role_id == 1
      table = Table.where(["slug = ?",params[:slug]]).first
    else
      table = Table.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    end
    
    directory = File.join("vendor","assets","images","uploads","tables")
    old_path = File.join(directory,table.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    table.featured_image = ""
    table.save
    render json: { "gst": "deleted" } 
  end

  def update
    if current_user.role_id == 1
      @table = Table.where(["slug = ?",params[:slug]]).first
    else
      @table = Table.where(["slug = ? AND user_id = ?",params[:slug],current_user.id]).first
    end
    
    if @table.update_attributes(table_params(@table.featured_image))
      flash[:notice] = "Table saved"
      redirect_to(:action=>'index')
    else
      @table_count = Table.count
      render("edit")
    end
  end

  private
  def table_params(old_image)
    if old_image.blank?
      old_image = "test"
    end
    if !params[:table][:featured_image].blank?
      params[:table][:featured_image]= upload_files_custom(params[:table][:featured_image],"tables",old_image)
    end
    if params[:table][:slug].blank?
       params[:table][:slug] = (params[:table][:title]+Time.now.to_i.to_s).parameterize
    else
        params[:table][:slug] = params[:table][:slug].parameterize
    end
    params.require(:table).permit(:title,:slug,:status,:position,:chairs,:featured_image,:hours)
  end
end
