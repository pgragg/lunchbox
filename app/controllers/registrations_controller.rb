class RegistrationsController < Devise::RegistrationsController 
  def create
    @user = User.new(user_params)
    @user.choose_role
    @user.choose_menu_id
     if @user.save
       flash[:error] = "User was saved successfully."
     else
       flash[:error] = "Error creating user. Please try again."
     end
    super
  end

  def new
    super
  end

  def edit
    super
  end

  def update
    super
  end
end

private
 
   def user_params
     params.require(:user).permit(:name, :menu_id, :role, :campus, :grade)
   end
 # def choose_role
 #    if self.email.include? "2"
 #      self.role = "student" 
 #    elsif self.role != "admin"
 #      self.role = "faculty" 
 #    else
 #      self.role = "error"
 #    end
 #    return nil
 #  end 

 #  def choose_menu_id
 #    if self.campus == "DWT"
 #      self.menu_id = (self.role == "faculty" ? 1 : 2) # Setting the user menu id depending on their role. 
 #    else 
 #      self.menu_id = (self.role == "faculty" ? 3 : 4) #self.role == faculty is checked because of the ID of the different menus. 
 #    end 

 #  end 