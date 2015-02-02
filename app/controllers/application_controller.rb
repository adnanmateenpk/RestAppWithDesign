class ApplicationController < ActionController::Base
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
end
