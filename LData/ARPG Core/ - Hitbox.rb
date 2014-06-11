class Hitbox
=begin
=end
  attr_accessor :owner
  attr_accessor :shape, :range
  def initialize(owner)
    @owner = owner
  end
  
  def hit?(target)
    a = @owner.x
    b= @owner.y
    
    
  end
  
end