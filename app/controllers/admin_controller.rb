class AdminController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  authorize_resource :class => false
  def index
  end

  def settings
  	@setting = Setting.all.first
  end

  def settings_save
  	@setting = Setting.all.first
  	if @setting.update_attributes(setting_params(@setting))
      flash[:notice]="Settings Saved successfully"
      redirect_to(:action=>'index')
    else
      render('settings')
    end 
  	
  end

  def remove_logo
    @setting = Setting.all.first
    directory = File.join("vendor","assets","images","uploads","logo")
    old_path = File.join(directory,@setting.logo)
    File.delete(old_path) if File.exist?(old_path)
    @setting.logo = ""
   	@setting.save
    render json: { "gst" => "deleted" } 
  end

  private
  def setting_params(setting)
    if setting.logo.blank?
      setting.logo = "test"
    end
    if !params[:setting][:logo].blank?
      params[:setting][:logo]= upload_files_custom(params[:setting][:logo],"logo",setting.logo)
    else 
      params[:setting][:logo] = ""  
    end
    
    params.require(:setting).permit(:title,:address,:company_name,:logo,:phone,:fax,:email,:meta_description,:meta_keywords)
  end
end
