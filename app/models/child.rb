class Child < ActiveRecord::Base
  after_save :define_menu_id
  after_update :define_menu_id

  belongs_to :user
  has_and_belongs_to_many :lunches, through: :lunch_choices
  has_many :lunch_choices, dependent: :destroy 
  belongs_to :menu 

  scope :by_menu, ->(id) { where(menu_id: id)}
  scope :by_campus, ->(campus) { where(campus: campus)}
  default_scope { order('last_name ASC') }
  scope :by_grade, ->(grade) { where(grade: grade)}

  validates :first_name, :presence => true 
  validates :last_name, :presence => true
  validates :grade, :presence => true

  GRADES = %w[threes fours k 1 2 3 4 5 6 7]
  ECD_GRADES = %w[threes fours k]
  DWT_GRADES = %w[1 2 3 4 5 6 7]

  def parent # Finds the child's parent. 
    User.find(self.user_id)
  end 

  def parent? #Children cannot be parents. 
    false
  end

  def admin? #Children cannot be admin. 
    false
  end

  def faculty? 
    false
  end

  def staff? #Children cannot be staff. 
    false
  end

  def self.search(search_term, search)
    if search_term != '' && search != ''
      search_term ||= 'last_name'
      where("#{search_term} LIKE ?", "#{search}")
    else
      all
    end
  end

  def self.ids_in_grade(grade)
    ids = []
    self.by_grade(grade).each do |child|
      ids << child.id
    end 
    ids
  end 

  def show_grade_or_role
    self.grade 
  end

  def choice_for?(date, lunch_id)
    lunches = Lunch.by_menu(2).by_day(date).to_a if self.campus == "DWT"
    lunches = Lunch.by_menu(4).by_day(date).to_a if self.campus == "ECD"
    (self.chose(lunches[lunch_id]) == nil ? "" : "1") 
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
    if lunch 
      lunch_choices.where(lunch_id: lunch.id).last 
    else 
      false 
    end 
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

  def define_grade 
    if self.email 
      if self.email.include?("@dwight.edu")
        year = self.email.split('')[0..3].join.to_i 
        return nil unless year.class == Fixnum 
        years_til_grad = year - Time.now.year 
        grade = 12-years_til_grad
        grade = Child.month_correct(grade)
        grade = Child.ecd_correct(grade)
        self.grade = grade 
      end 
    else 
      self.grade ||= nil #could be a problem if choose_grade is hooked into updating faculty grades. 
    end
  end 

  def define_campus
    if self.grade
      if Child::ECD_GRADES.include?(self.grade)
        self.campus = "ECD"
      else 
        self.campus = "DWT"
      end 
    end
  end
  
  def define_menu_id
    #define_grade
    previous_campus = self.campus 
    define_campus
    if (menu_id == nil || self.campus != previous_campus)
      self.menu_id = Menu.id_for(self.grade, "students", self.campus) #Updates menu if it detects that you've changed the child's campus. 
      self.destroy_my_lunch_choices
      self.save!
    end 
  end 

  def destroy_my_lunch_choices
    self.lunch_choices.each {|lc| lc.delete}
  end

  def destroy_lunch_choices_on(date, type)
    self.lunch_choices.by_date(date).each do |lc|
      lc.destroy if lc.lunch.lunch_type == type 
    end
  end 

  def lunch_choices_count(type)
    i = 0
    self.lunch_choices.eager.each do |lc| 
      i += 1 if lc.lunch.lunch_type == "#{type}" 
    end
    i
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
