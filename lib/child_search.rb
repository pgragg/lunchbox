module ChildSearch

  module Matches 

    def no_existing_match(child)
      Match.find("#{self.id}#{child.id}".to_i) == nil 
    end

    def new_match(child,amount)
      if no_existing_match(child)
        match = Match.create(
          id1: self.id, 
          id2: child.id, 
          dismissed: false, 
          amount: amount)
        match.set_id
      end 
    end

    def compare(child, amount)
      new_match if similar_to(child, amount)
    end 

    def compare_to_all_in_grade(amount)
      Child.by_grade(self.grade).each do |child|
        compare(child, amount)
      end
    end

    def self.compile_matches
      Child::GRADES.each {|grade|
        Child.all.by_grade(grade).each {|child| 
          child.compare_to_all_in_grade(amount)
        }
      }
    end

  end 


  module Similarities

    def property(attribute)
      case attribute 
      when "last_name"
        return self.last_name
      when "first_name"
        return self.first_name
      end
    end

    def shared(property)
      Child.search(property, self.property(property)).where("id != ?", self.id).to_a
    end

    def similar_to_anyone_by(amount)
      if self.other_similar_by(amount) != nil
        self.other_similar_by(amount)
      end
    end 

    def other_similar_by(amount)
      #Search the child's grade for any inexact matches.
      array = []
      Child.all.by_grade(self.grade).each do |child| 
        array << child.matching_classmates_by(amount) unless array.flatten.include?(self)
      end 
      array.flatten!
    end

    def matching_classmates_by(amount)
      array = []
      Child.all.by_grade(self.grade).each {|child| 
        return array << child if self.a_good_match(child, amount)
      } 
      array 
    end

    def a_good_match(child, amount)
      self.similar_to(child, amount) && (child.user_id != self.user_id)
    end

    def similar_to(child, amount)
      t1 = self.similarity("last_name", child.last_name)
      t2 = self.similarity("first_name", child.first_name)
      (t1 + t2).to_i >= (amount * 2) 
    end

    def similarity(property, given)
      self.property(property).similar(given) #.at_least?(amount.to_i)
      #Is the child's property (eg last_name) #{amount}% similar to the given? 
      #the similar method is provided by the similar_text gem. 
      # "Hello, World!".similar("Hello World!") #=> 96.0
    end
  end
end