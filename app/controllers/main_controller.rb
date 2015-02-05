class MainController < ApplicationController
  def index
  
  end

  def subscription

  end

  def convert_user
  	current_user.role_id = 2
  	current_user.save
  	flash[:notice]="You can now add your own Restaurants"
  	redirect_to root_url
  end

end
