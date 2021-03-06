class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #validates_format_of :email, :without => /(\\d+).*?((?:[a-z][a-z\\.\\d_]+)\\.(?:[a-z\\d]{3}))(?![\\w\\.])/, :message => "Children can not sign up for accounts. Use a parent's email address!"
  before_save :define_role
  after_update :define_menu_id
  before_save :define_menu_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :children, dependent: :delete_all 
  #Used delete_all to destroy Child records when Parent deleted by admin.
  #The child_controller destroy method only destroys the children of the current user.  
  belongs_to :menu 
  has_many :lunch_choices, dependent: :destroy 
  scope :by_role, ->(role) { where(role: role)}
  scope :by_campus, ->(campus) { where(campus: campus)}
  scope :by_grade, ->(grade) { where(grade: grade)}


  def self.search(search_term, search)
    if search_term != '' && search != ''
      search_term ||= 'last_name'
      where("#{search_term} LIKE ?", "#{search}")
    else
      all
    end
  end

  def child?
    email.split('').include?('2') && email.split('@').include?('dwight.edu')
  end

  def delete_if_child
    if child? 
      self.delete 
    end
  end

  def redirect_if_menu_id_invalid
    self.define_campus 
    self.define_menu_id
    redirect_to user_path(self.id) if self.menu_id == nil
  end 

  def show_grade_or_role 
    (self.grade != Child::GRADES ? self.role : self.grade)
  end 


  def self.ids_in_grade(grade)
    grade = [nil, ""] if (grade == "" || grade == nil) 
    ids = []
    # if (grade == nil)
    #   self.by_grade("").each do |user|
    #     ids << user.id
    #   end   
    # end
    # if (grade == "")
    #   self.by_grade(nil).each do |user|
    #     ids << user.id
    #   end   
    # end
    self.by_grade(grade).each do |user|
      ids << user.id
    end 
    ids
  end 


  def self.ids_in_role(role)
    ids = []
    self.by_role(role).each do |user|
      ids << user.id
    end 
    ids
  end 

  def admin? 
    self.role == "admin"
  end 

  def faculty? 
    self.role == "faculty"
  end 

  def staff? 
    self.role == "staff"
  end 

  def faculty_or_staff? 
    self.faculty? || self.staff? 
  end 

  def parent? 
    self.role != "admin" && self.role != "faculty" && self.role != "staff"
  end 

  def choice_for?(date, lunch_id)
    lunches = Lunch.by_menu(self.menu_id).by_day(date).to_a
    (self.chose(lunches[lunch_id]) == nil ? "" : "1") 
  end

  def chose(lunch)
    if lunch 
      lunch_choices.where(lunch_id: lunch.id).last 
    end 
  end

  def destroy_lunch_choices_on(date, type)
    if date 
      self.lunch_choices.by_date(date).each do |lc|
        lc.destroy if lc.lunch.lunch_type == type 
      end
    end
  end 

  def lunch_choices_count(type)
    i = 0
    self.lunch_choices.eager.each do |lc| 
      i += 1 if lc.lunch.lunch_type == "#{type}" 
    end
    i
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

  # def add_child_button
  #   if self.parent? 
  #     return link_to "Add a child", new_user_child_path(self), class: button_class
  #   end 
  # end 

  def define_role
    if self.role == nil 
      self.role ||= (self.email.include?("dwight.edu") ? "faculty" : "parent")
      self.save!
    end 
  end 

  def define_campus
    if self.grade 
      if Child::ECD_GRADES.include?(self.grade)
        self.campus = "ECD"
      elsif Child::DWT_GRADES.include?(self.grade)
        self.campus = "DWT"
      else 
        self.campus ||= nil 
      end 
    end
  end

  # def define_menu_id
  #   self.menu_id = Menu.id_for(self.grade, self.role, self.campus) #Updates menu if it detects that you've changed the child's campus. 
  #   self.save! 
  # end 

  def destroy_my_lunch_choices
    self.lunch_choices.each {|lc| lc.delete}
  end

  def define_role
    if self.role == nil 
      self.role ||= (self.email.include?("dwight.edu") ? "staff" : "parent")
      self.save!
    end 
  end 

  def define_menu_id
    previous_id = self.menu_id 
    self.menu_id = Menu.id_for(self.grade, self.role, self.campus)
    if menu_id != previous_id#Protects against recursion upon save.. 
       #Saves user if it detects that you've changed the user's menu_id. 
      self.destroy_my_lunch_choices
      self.save!
    end 
    delete_if_child
  end 

  private 

  
  
  
  

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
