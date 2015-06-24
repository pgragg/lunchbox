class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Pundit

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    return (current_user.admin? ? menu_index_path : user_children_path(current_user.id)) 
    #Everything after here is unused. 
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || admin_panel_path
    end
  end

  def index
    if @user.menu_id
      @menu = Menu.find(@user.menu_id)
    end
    @children = current_user.children
  end 

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :campus
  end
end
