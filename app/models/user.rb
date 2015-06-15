class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_save :define_role
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :children
  belongs_to :menu 
  has_many :lunch_choices, dependent: :destroy 
  scope :by_role, ->(role) { where(role: role)}
  scope :by_campus, ->(campus) { where(campus: campus)}
  scope :by_grade, ->(grade) { where(grade: grade)}

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

  def all_faculty
    User.by_role('faculty').by_grade(nil)
  end

  def ecd_sp_deliv 
    User.by_role('faculty').by_grade(Child::ECD_GRADES)
  end

  def dwt_sp_deliv 
    User.by_role('faculty').by_grade(Child::DWT_GRADES)
  end 

  private 
  
  def define_role
    if self.role == nil
      self.role = (self.email.include?("dwight.edu") ? "faculty" : "parent")
      self.save!
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
