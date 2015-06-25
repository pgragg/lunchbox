class Users::SessionsController < Devise::SessionsController
 before_filter :configure_sign_in_params, only: [:create]
 skip_before_filter :auth_user
 

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
    params = [:email, :password, :campus, :role, :grade]
    devise_parameter_sanitizer.for(:sign_in) << :params 
  end
end
