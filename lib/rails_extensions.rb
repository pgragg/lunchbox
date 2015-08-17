class Array 

  def at_least?(amount)
    self.count >= amount.to_i
  end 

end 

class Integer 

  def at_least?(amount)
    amount = amount.to_i
    self >= amount.to_i
  end 

end 


class Float 

  def at_least?(amount)
    amount = amount.to_i
    self >= amount
  end 

end 

