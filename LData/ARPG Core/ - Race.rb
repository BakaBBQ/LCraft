class Race
  def size_range
  end
  
  def body_type
  end

  def name
    return "Void"
  end
end

class Human < Race
  def name
    return "Human"
  end
end