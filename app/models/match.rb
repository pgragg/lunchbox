class Match < ActiveRecord::Base

  # attr_accessor :id1, :id2, :dismissed, :amount 

  def child(place) #call pair.child(1) or pair.child(2) to return that part of the pair. 
    choice = place == 1 ? id1 : id2 
    child = Child.find(choice)
  end

  def self.list_of_ids
    array = []
    self.all.each {|match| 
      array << [match.id1, match.id2] if match.dismissed != true 
    }
    array.flatten.uniq!
  end

  def self.children
    children = []
    self.list_of_ids.each {|id|
      children << Child.find(id) unless id == nil 
    }
    children 
  end

  def set_id
    id = "#{id1}#{id2}".to_i
    save!
  end

end