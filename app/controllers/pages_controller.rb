class PagesController < ApplicationController
  before_action :auth_user
  layout 'admin'
  authorize_resource :class => false
  def index
    @pages = Page.sorted
  end

  def show
    @page = Page.where(["slug = ?",params[:slug]]).first
  end

  def new
    @page_count = Page.count+1
    @page = Page.new
    @layouts = Layout.all
    
  end

  def create 
    @page = Page.new(page_params("test"))
    if @page.save
      flash[:notice]="Page created successfully"
      redirect_to(:action=>'index')
    else
      @layouts = Layout.all
      
      @page_count = Page.count + 1
      render('new')
    end 	
  end

  def edit
    @page_count = Page.count
    @page = Page.where(["slug = ?",params[:slug]]).first 
    @layouts = Layout.all
    
  end

  def update
    @page = Page.where(["slug = ?",params[:slug]]).first 
    if @page.update_attributes(page_params(@page.featured_image))
      flash[:notice]="Page update successfully"
      redirect_to(:action=>'index')
    else
      @layouts = Layout.all
      
      @page_count = Page.count
      render('edit')
    end 
  end
  def remove_image
    page = Page.where(["slug = ?",params[:slug]]).first 
    directory = File.join("vendor","assets","images","uploads","pages")
    old_path = File.join(directory,page.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    page.featured_image = ""
    page.save
    render json: { "gst" => "deleted" }
  end
  def destroy
    page = Page.where(["slug = ?",params[:slug]]).first 
    if page.featured_image.blank?
      page.featured_image = "test"
    end
    directory = File.join("vendor","assets","images","uploads","pages")
    old_path = File.join(directory,page.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    page.destroy
    render json: { "gst" => "deleted" } 
  end

  private
  def page_params(old)
    if old.blank?
      old = "test"
    end
    if !params[:page][:featured_image].blank?
      params[:page][:featured_image]= upload_files_custom(params[:page][:featured_image],"pages",old)
    end
    if params[:page][:slug].blank?
       params[:page][:slug] = params[:page][:title].parameterize
    else
        params[:page][:slug] = params[:page][:slug].parameterize
    end
    params.require(:page).permit(:title,:slug,:status,:position,:html,:layout_id,:featured_image,:meta_description,:meta_keywords)
  end

end
