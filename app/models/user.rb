class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :children
  scope :by_role, ->(role) { where(role: role)}

  #has_many :lunch_choices #This relationship is currently not working. 
  #I think I need to drop and remigrate the table. 

  def admin? 
    self.role == "admin"
  end 

  def faculty? 
    self.role == "faculty"
  end 

  def parent? 
    self.role == "parent"
  end 

  def meets_grade_deliv_requirements
    return true if (self.role == "student" || (self.role == "faculty" && self.campus = "DWT" && Random.rand(1..3)== 1))
  end 


  def chose(lunch)
      lunch_choices.where(lunch_id: lunch.id).last 
  end

  def destroy_lunch_choices_on(date)
    self.lunch_choices.each do |lc|
      lc.destroy if lc.date == date 
    end
  end 

  def define_menu_id
      self.menu_id = (self.campus == "DWT" ? 1 : 3)
  end 

  # def after_signin_path_for
  #   if (user.role == "admin")
  #     redirect_to menu_path(self.menu_id)
  #   else 
  #     redirect_to admin_panel_path
  #   end 
  # end

  

#Menu_ids are set in the order that they are created: 
  # DWT FAC -> 1
  # DWT STUD -> 2
  # ECD FAC -> 3
  # ECD STUD -> 4


  # def what_was_chosen
  #   self.lunch_choices.select{|lc| lc.lunch.date = @lunch.date}
  # end 

#Roles should include, at some point, information about whether the user is ECD,
#or Dwight main, or faculty, etc. This will help #show the right @lunch. 



end
