class PagesController < ApplicationController
  def index
    @pages = Page.all.sorted
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
    @page = Page.new(page_params)
    if @page.save
      flash[:notice]="Page created successfully"
      redirect_to(:action=>'index')
    else
      @page_count = Page.count + 1
      render('new')
    end 	
  end

  def edit
    @page_count = Page.count
    @page = Page.where(["slug = ?",params[:slug]]).first
    layouts = Layout.all
    @layouts = Array.new
    layouts.each_with_index do |l,i|
      @layouts[i] = Array.new
      @layouts[i] = [l.title,l.id] 
    end
  end

  def update
    @page = Page.where(["slug = ?",params[:slug]]).first
    if @page.update_attributes(page_params)
      flash[:notice]="Page update successfully"
      redirect_to(:action=>'index')
    else
      @page_count = Page.count + 1
      render('edit')
    end 
  end

  def destroy
    Page.where(["slug = ?",params[:slug]]).first.destroy
    render json: { "gst": "deleted" } 
  end

  private
  def page_params
    if params[:page][:slug].blank?
       params[:page][:slug] = params[:page][:title].parameterize
    else
        params[:page][:slug] = params[:page][:slug].parameterize
    end
    params.require(:page).permit(:title,:slug,:status,:position,:html,:layout_id)
  end

end
