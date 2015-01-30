class PostsController < ApplicationController
  def index
    @posts = Post.all.sorted
  end

  def show
    @post = Post.where(["slug = ?",params[:slug]]).first
  end

  def new
    @post_count = Post.count+1
    @post = Post.new
    
  end

  def create 
    @post = Post.new(post_params)
    if @post.save
      flash[:notice]="Post created successfully"
      redirect_to(:action=>'index')
    else
      @post_count = Post.count + 1
      render('new')
    end 	
  end

  def edit
    @post_count = Post.count
    @post = Post.where(["slug = ?",params[:slug]]).first
    
  end

  def update
    @post = Post.where(["slug = ?",params[:slug]]).first
    if @post.update_attributes(post_params)
      flash[:notice]="Post update successfully"
      redirect_to(:action=>'index')
    else
      @post_count = Post.count + 1
      render('edit')
    end 
  end
  def remove_image
    @post = Post.where(["slug = ?",params[:slug]]).first
    @post.featured_image = ""
    @post.save
    render json: { "gst": "deleted" } 
  end
  def destroy
    Post.where(["slug = ?",params[:slug]]).first.destroy
    render json: { "gst": "deleted" } 
  end

  private
  def post_params
  	if !params[:post][:featured_image].blank?
      params[:post][:featured_image]= upload_files_custom(params[:post][:featured_image],"posts")
    else 
      params[:post][:featured_image] = ""  
    end
    if params[:post][:slug].blank?
       params[:post][:slug] = params[:post][:title].parameterize
    else
        params[:post][:slug] = params[:post][:slug].parameterize
    end
    params.require(:post).permit(:title,:slug,:status,:position,:html,:featured_image)
  end
end
