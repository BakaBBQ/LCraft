class PredefinedBodies
  
  
  
end


class << PredefinedBodies
  def body_wsize(x)
    b = HumanBody.new
    b.gen(x)
    return b
  end
  
  def small
    body_wsize(58)
  end
  
  def normal
    body_wsize(65)
  end
  
  def big
    body_wsize(75)
  end
end
