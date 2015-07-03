class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :auth_user
  before_filter :authenticate_user!, except: [:index]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Pundit

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    return user_root_path
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || admin_panel_path(current_user.id)
    end
  end

  def index
    if @user.menu_id
      @menu = Menu.find(@user.menu_id)
    end
      @children = current_user.children
  end 

  def user_root_path
    if current_user
      return case current_user.role 
        when "admin" 
          admin_panel_index_path(current_user.id)
        when "faculty" 
          current_user.redirect_if_menu_id_invalid
          current_user.sign_in_count >= 2 ? menu_path(current_user.menu_id) : edit_user_registration_path(current_user.id)
        when "staff" 
          current_user.redirect_if_menu_id_invalid
          current_user.sign_in_count >= 2 ? menu_path(current_user.menu_id) : edit_user_registration_path(current_user.id)
        else 
          user_children_path(current_user.id)
      end
    end
  end

  protected

  def auth_user
    #redirect_to welcome_index_path unless (current_user || params[:confirmation_token])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :campus << :role << :grade 
    devise_parameter_sanitizer.for(:account_update) << :campus << :role << :grade << :first_name << :last_name 
  end
end
