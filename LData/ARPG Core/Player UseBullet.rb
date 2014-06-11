class Game_Player
  def try_use_skill s
    if affordable? s
      use_skill s
    end
  end
  
  def affordable? s
    self.mp >= s.mp_cost
  end
    
  def use_skill s
    self.mp -= s.mp_cost
    use s.id
  end
  
  def update
    super
    if Input.trigger?(:L)
      use 129
    end
  end
  
end
