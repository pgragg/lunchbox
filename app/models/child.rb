class Child < ActiveRecord::Base
  after_save :define_menu_id
  after_update :define_menu_id

  belongs_to :user
  has_and_belongs_to_many :lunches, through: :lunch_choices
  has_many :lunch_choices, dependent: :destroy 
  belongs_to :menu 

  scope :by_menu, ->(id) { where(menu_id: id)}
  scope :by_campus, ->(campus) { where(campus: campus)}

  scope :by_grade, ->(grade) { where(grade: grade)}

  GRADES = %w[threes fours k 1 2 3 4 5 6 7]
  ECD_GRADES = %w[threes fours k]
  DWT_GRADES = %w[1 2 3 4 5 6 7]

  def self.ids_in_grade(grade)
    ids = []
    self.by_grade(grade).each do |child|
      ids << child.id
    end 
    ids
  end 

  def choose_seed_grade #Just using this for the seeds.rb file to determine a random campus for students. 
    if self.campus == "DWT"
      g = Random.rand(1..7)
    else 
      determinant = Random.rand(1..3)
      g = "k" if determinant == 3
      g = "fours" if determinant == 2
      g = "threes" if determinant == 1
    end 
    self.grade = g
  end

  def chose(lunch)
    lunch_choices.where(lunch_id: lunch.id).last 
  end 

  def self.month_correct(grade)
    beginning_of_year = [6, 7, 8, 9, 10, 11, 12]
    if beginning_of_year.include?(Time.now.month) 
      grade += 1 
    end 
    grade 
  end 

  def self.ecd_correct(grade)
    case grade 
       when 0
        result = 'k'
       when -1 
        result = 'fours'
       when -2 
        result = 'threes'
       else 
        result = grade 
      end 
    result 
  end 

  def choose_grade 
    if self.email.include?("@dwight.edu")
      year = self.email.split('')[0..3].join.to_i 
      return nil unless year.class == Fixnum 
      years_til_grad = year - Time.now.year 
      grade = 12-years_til_grad
      grade = Child.month_correct(grade)
      grade = Child.ecd_correct(grade)
      self.grade = grade 
    else 
      self.grade = nil #could be a problem if choose_grade is hooked into updating faculty grades. 
    end 
  end 





  def choose_campus
    if Child::ECD_GRADES.include?(self.grade)
      self.campus = "ECD"
    else 
      self.campus = "DWT"
    end 
  end
  def define_menu_id
    choose_grade
    previous_campus = self.campus 
    choose_campus
    if (menu_id == nil || self.campus != previous_campus)
      self.menu_id = (self.campus == "DWT" ? 2 : 4) #Updates menu if it detects that you've changed the child's campus. 
      self.save!
    end 
  end 
  def destroy_lunch_choices_on(date)
    self.lunch_choices.each do |lc|
      lc.destroy if lc.date == date 
    end
  end 

  def ecd_children 
    Child.by_grade(Child::ECD_GRADES)
  end
  def dwt_lower
    Child.by_grade(%w[1 2 3 4])
  end 
  def dwt_mid
    Child.by_grade(%w[5 6 7])
  end 

  private
    
   
    
  
end
