class Users::RegistrationsController < Devise::RegistrationsController
  layout "devise_sessions"
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    redirect_to :root
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      
      flash[:registration_errors] = resource.errors.full_messages
      flash[:registration_model] = resource

      redirect_to :root
    end
      AdminMailer.welcome_email(@user).deliver_now unless @user.invalid?
  end

  # GET /resource/edit
  def edit
    redirect_to :root
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{:user}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      flash[:edit_detail_errors] = resource.errors.full_messages
      redirect_to :root
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  def sign_up_params
    params[:user][:role_id] = "3"
    params[:user][:membership] =  Digest::SHA1.hexdigest(params[:user][:email])[0,6]
    params.require(:user).permit(:name, :role_id , :email, :password, :password_confirmation,:phone,:membership,:time_zone)
  end

  # You can put the params you want to permit in the empty array.
  def account_update_params
   params[:user][:membership] =  Digest::SHA1.hexdigest(params[:user][:email])[0,6]
    params.require(:user).permit(:name, :email, :password, :password_confirmation,:phone,:current_password)
  end
  
  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
