class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :lunches, through: :lunch_choices
  has_many :lunch_choices, dependent: :destroy 
  #has_many :lunch_choices #This relationship is currently not working. 
  #I think I need to drop and remigrate the table. 

  def admin? 
    self.role == "admin"
  end 

  def student? 
    self.role == "student"
  end 

  def chose(lunch)
    lunch_choices.where(lunch_id: lunch.id).first
  end

#Roles should include, at some point, information about whether the user is ECD,
#or Dwight main, or faculty, etc. This will help #show the right @lunch. 



end
