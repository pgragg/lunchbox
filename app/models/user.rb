class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :lunches, through: :lunch_choices
  has_many :lunch_choices, dependent: :destroy 
  belongs_to :menu 

  scope :by_menu, ->(id) { where(menu_id: id)}
  scope :by_campus, ->(campus) { where(campus: campus)}
  scope :by_role, ->(role) { where(role: role)}
  scope :by_grade, ->(grade) { where(grade: grade)}
  #has_many :lunch_choices #This relationship is currently not working. 
  #I think I need to drop and remigrate the table. 

  def admin? 
    self.role == "admin"
  end 

  def student? 
    self.role == "student"
  end 

  def faculty? 
    self.role == "faculty"
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

  # def after_signin_path_for
  #   if (user.role == "admin")
  #     redirect_to menu_path(self.menu_id)
  #   else 
  #     redirect_to admin_panel_path
  #   end 
  # end

  def choose_grade #Just using this for the seeds.rb file to determine a random campus for students. 
    if self.campus == "DWT"
      g = Random.rand(1..7)
    else 
      determinant = Random.rand(1..3)
      g = "k" if determinant == 3
      g = "4s" if determinant == 2
      g = "3s" if determinant == 1
    end 
    self.grade = g
    
  end 

  def choose_role
    if self.email.include? "2"
      self.role = "student" 
    elsif self.role != "admin"
      self.role = "faculty" 
    else
      self.role = "error"
    end

    #self.role = "faculty" if (self.role != "student" && self.role != "admin")
    #self.role = (self.email.to_s.include? "2" ? "student" : "faculty")
    return nil
  end 

  def choose_menu_id
    self.choose_role
    if self.campus == "DWT"
      self.menu_id = (self.role == "faculty" ? 1 : 2) # Setting the user menu id depending on their role. 
    else 
      self.menu_id = (self.role == "faculty" ? 3 : 4) #self.role == faculty is checked because of the ID of the different menus. 
    end 

  end 

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
