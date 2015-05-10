class WelcomeController < ApplicationController
  
  def index
    render :layout => '_landing'
    #render :stylesheet => 'welcome.scss'
  end
end
