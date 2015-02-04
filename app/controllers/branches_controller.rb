class BranchesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  def index
    @branches = Branch.sorted
  end

  def edit
    @branch = Branch.where(["slug = ?",params[:slug]]).first 
    @branch_count = Branch.count
    
  end

  def new
    @branch_count = Branch.count + 1
    @branch = Branch.new
  end
  
  def create
    @branch_count = Branch.count + 1
    @branch = Branch.new(branch_params("test"))
    if @branch.save
      flash[:notice] = "Branch saved"
      redirect_to(:action=>'index')
    else
      render("new")
    end

  end

  def destroy
    branch = Branch.where(["slug = ?",params[:slug]]).first 
    
    if branch.featured_image.blank?
      branch.featured_image = "test"
    end
    directory = File.join("vendor","assets","images","uploads","branches")
    old_path = File.join(directory,branch.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    branch.destroy
    render json: { "gst": "deleted" } 
  end

  def remove_image
    branch = Branch.where(["slug = ?",params[:slug]]).first 
    directory = File.join("vendor","assets","images","uploads","branches")
    old_path = File.join(directory,branch.featured_image)
    File.delete(old_path) if File.exist?(old_path)
    branch.featured_image = ""
    branch.save
    render json: { "gst": "deleted" } 
  end

  def update

    @branch = Branch.where(["slug = ?",params[:slug]]).first 
    if @branch.update_attributes(branch_params(@branch.featured_image))
      flash[:notice] = "Branch saved"
      redirect_to(:action=>'index')
    else
      @branch_count = Branch.count
      render("edit")
    end
  end

  private
  def branch_params(old_image)
    if old_image.blank?
      old_image = "test"
    end
    if !params[:branch][:featured_image].blank?
      params[:branch][:featured_image]= upload_files_custom(params[:branch][:featured_image],"branches",old_image)
    end
    if params[:branch][:slug].blank?
       params[:branch][:slug] = params[:branch][:title].parameterize
    else
        params[:branch][:slug] = params[:branch][:slug].parameterize
    end
    params.require(:branch).permit(:title,:slug,:status,:address,:email,:position,:phone,:fax,:featured_image)
  end
end
