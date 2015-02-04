class PagesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  def index
    @pages = Page.sorted
  end

  def show
    @page = Page.where(["slug = ?",params[:slug]]).first
  end

  def new
    @page_count = Page.count+1
    @page = Page.new
    layouts = Layout.all
    @layouts = Array.new
    layouts.each_with_index do |l,i|
      @layouts[i] = Array.new
      @layouts[i] = [l.title,l.id] 
    end
  end

  def create 
    @page = Page.new(page_params(Page.new(:featured_image => "test")))
    if @page.save
      flash[:notice]="Page created successfully"
      redirect_to(:action=>'index')
    else
      layouts = Layout.all
      @layouts = Array.new
      layouts.each_with_index do |l,i|
        @layouts[i] = Array.new
        @layouts[i] = [l.title,l.id] 
      end
      @page_count = Page.count + 1
      render('new')
    end 	
  end

  def edit
    @page_count = Page.count
    @page = Page.where(["slug = ?",params[:slug]]).first or not_found
    layouts = Layout.all
    @layouts = Array.new
    layouts.each_with_index do |l,i|
      @layouts[i] = Array.new
      @layouts[i] = [l.title,l.id] 
    end
  end

  def update
    @page = Page.where(["slug = ?",params[:slug]]).first or not_found
    if @page.update_attributes(page_params(@page))
      flash[:notice]="Page update successfully"
      redirect_to(:action=>'index')
    else
      layouts = Layout.all
      @layouts = Array.new
      layouts.each_with_index do |l,i|
        @layouts[i] = Array.new
        @layouts[i] = [l.title,l.id] 
      end
      @page_count = Page.count
      render('edit')
    end 
  end
  def remove_image
    page = Page.where(["slug = ?",params[:slug]]).first or not_found
    directory = File.join("vendor","assets","images","uploads","pages")
    old_path = File.join(directory,page.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    page.featured_image = ""
    page.save
    render json: { "gst": "deleted" } 
  end
  def destroy
    page = Page.where(["slug = ?",params[:slug]]).first or not_found
    if page.featured_image.blank?
      page.featured_image = "test"
    end
    directory = File.join("vendor","assets","images","uploads","pages")
    old_path = File.join(directory,page.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    page.destroy
    render json: { "gst": "deleted" } 
  end

  private
  def page_params(page)
    if page.featured_image.blank?
      page.featured_image = "test"
    end
    if !params[:page][:featured_image].blank?
      params[:page][:featured_image]= upload_files_custom(params[:page][:featured_image],"pages",page.featured_image)
    end
    if params[:page][:slug].blank?
       params[:page][:slug] = params[:page][:title].parameterize
    else
        params[:page][:slug] = params[:page][:slug].parameterize
    end
    params.require(:page).permit(:title,:slug,:status,:position,:html,:layout_id,:featured_image,:meta_description,:meta_keywords)
  end

end
