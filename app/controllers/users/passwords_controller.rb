class Users::PasswordsController < Devise::PasswordsController
  layout "devise_sessions"
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = "Email Sent Please Follow the instructions"
      redirect_to :root
    else
      flash[:alert] = resource.errors.full_messages[0] == "Email not found" ? "Email doesnt exist in the database" : " "
      redirect_to :root
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    flash[:reset_token] = params[:reset_password_token]
    redirect_to :root
  end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
