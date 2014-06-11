class BodyPart
  attr_accessor :size
  attr_accessor :damage
  attr_accessor :name
  
  attr_accessor :wielding # ItemStack, the thing that is holding, such as a knife in a hand
  attr_accessor :protection # ItemStack, the thing that covers the part, such as glove in a hand
  
  attr_accessor :owner # the body owner
  def initialize
    @damage = 0
    @size = 65
  end
  
  def hand?
    return true
  end
  
  
  def name
    return self.class.name unless @name
    return @name
  end
  
  def coverage_type
    return self.class
  end
  
  def wield(itemstack)
    self.wielding = itemstack unless @wielding
  end
end

%w(hand arm foot leg head neck upperbody lowerbody eye ear nose).each do |s|
  Object.const_set s.capitalize.to_sym, Class.new(BodyPart)
end

