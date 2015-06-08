class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Pundit

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    current_user.choose_role
    current_user.save!
    current_user.choose_menu_id
    current_user.save!
    return (current_user.admin? ? menu_index_path : menu_path(current_user.menu_id)) 
    #Everything after here is unused. 
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || menu_index_path
    end
  end

  def index
    @menu = Menu.find(@user.menu_id)
  end 
end
