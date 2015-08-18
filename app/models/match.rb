class Match < ActiveRecord::Base

  belongs_to :child 
  default_scope { order('dismissed ASC') } 

  # attr_accessor :id1, :id2, :dismissed, :amount 

  def child(place) #call pair.child(1) or pair.child(2) to return that part of the pair. 
    choice = place == 1 ? id1 : id2 
    child = Child.find_by_id(choice)
  end

  def invalidate
    self.dismissed = true 
    self.save! 
  end

  def validate
    self.dismissed = false 
    self.save! 
  end

  def self.list_of_ids
    array = []
    self.all.each {|match| 
      array << [match.id1, match.id2] if match.dismissed != true 
    }
    array.flatten.uniq
  end

  def self.children
    children = []
    if list_of_ids != nil 
      list_of_ids.each {|id|
        children << Child.find(id)
      }
    end
    children 
  end

  def self.key(id1, id2)
    [id1,id2].sort[0]
  end

  def make_key
    self.id = Match.key(id1, id2)
  end

  def make_key!
    self.make_key
    self.save! 
  end

end