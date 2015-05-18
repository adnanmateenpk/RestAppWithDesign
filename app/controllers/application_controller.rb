class ApplicationController < ActionController::Base
	before_filter :redirect_to_example if Rails.env.production?

  	# Prevent CSRF attacks by raising an exception.
 	 # For APIs, you may want to use :null_session instead.
 	 
  	protect_from_forgery with: :exception
	def upload_files_custom(file,path,old)
		
		name = Time.now.to_i.to_s+"_"+sanitize_filename(file.original_filename)
		directory = File.join("vendor","assets","images","uploads",path)
		FileUtils.mkdir_p(directory) unless File.directory?(directory)
		path = File.join(directory,name)
		old_path = File.join(directory,old)
		File.delete(old_path) if File.exist?(old_path)
		File.open(path,"wb"){|f| f.write(file.read)}
		name
	end

	def sanitize_filename(file_name)
		# get only the filename, not the whole path (from IE)
		just_filename = File.basename(file_name)
		# replace all none alphanumeric, underscore or perioids
		# with underscore
		just_filename.sub(/[^\w\.\-]/,'-')

	end
	rescue_from CanCan::AccessDenied do |exception|
		flash[:alert]  =  "You are not authorized to access this page"
		if user_signed_in? && current_user.role_id == 2
			redirect_to :controller => "admin" , :action => "index"
		else 
			redirect_to :controller => "main" , :action => "index"
		end

	end

  	def auth_user
    	redirect_to :root unless user_signed_in?
  	end
  	
	

	private

    # Redirect to the appropriate domain i.e. example.com
    def redirect_to_example
      domain_to_redirect_to = 'reservados.co'
      domain_exceptions = ['reservados.co', 'reservados.co']
      should_redirect = !(domain_exceptions.include? request.host)
      new_url = "#{request.protocol}#{domain_to_redirect_to}#{request.fullpath}"
      redirect_to new_url, status: :moved_permanently if should_redirect
    end
	  
end
