class PostsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  def index
    @posts = Post.sorted
  end

  def show
    @post = Post.where(["slug = ?",params[:slug]]).first
  end

  def new
    @post_count = Post.count+1
    @post = Post.new
    
  end

  def create 
    @post = Post.new(post_params(Post.new(:featured_image => "test")))
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
    @post = Post.where(["slug = ?",params[:slug]]).first or not_found
    
  end

  def update
    @post = Post.where(["slug = ?",params[:slug]]).first or not_found
    if @post.update_attributes(post_params(@post))
      flash[:notice]="Post update successfully"
      redirect_to(:action=>'index')
    else
      @post_count = Post.count + 1
      render('edit')
    end 
  end
  def remove_image
    post = Post.where(["slug = ?",params[:slug]]).first or not_found
    directory = File.join("vendor","assets","images","uploads","posts")
    old_path = File.join(directory,post.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    post.featured_image = ""
    post.save
    render json: { "gst": "deleted" } 
  end
  def destroy
    post = Post.where(["slug = ?",params[:slug]]).first or not_found
    directory = File.join("vendor","assets","images","uploads","posts")
    if post.featured_image.blank?
      post.featured_image = "test"
    end
    old_path = File.join(directory,post.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    post.destroy
    render json: { "gst": "deleted" } 
  end

  private
  def post_params(post)
    if post.featured_image.blank?
      post.featured_image = "test"
    end
  	if !params[:post][:featured_image].blank?
      params[:post][:featured_image]= upload_files_custom(params[:post][:featured_image],"posts",post.featured_image)
    end
    if params[:post][:slug].blank?
       params[:post][:slug] = params[:post][:title].parameterize
    else
        params[:post][:slug] = params[:post][:slug].parameterize
    end
    params.require(:post).permit(:title,:slug,:status,:position,:html,:featured_image,:meta_description,:meta_keywords)
  end
end
