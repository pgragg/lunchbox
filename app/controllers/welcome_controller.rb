class WelcomeController < ApplicationController
  skip_before_filter :auth_user
  
  def index
    render :layout => '_landing'
    #render :stylesheet => 'welcome.scss'
  end
end
