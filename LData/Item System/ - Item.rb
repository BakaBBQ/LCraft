# now - item
class Item
  attr_accessor :durability #(aka hp)
  attr_accessor :shape #(the shape of the sword)
  attr_accessor :enchantments # enchantments XD
  attr_accessor :engravings # and some engravings
  attr_accessor :size
  attr_accessor :materials # 1d array of the materials
  attr_accessor :owner
  def initialize
    @durability = max_durability
    @shape = :sword
    @enchantments = []
    @engravings = []
    @size = 0.0
    @materials = Array.new(10){$data_materials[:iron]}
  end
  
  def max_durability
    return 100
  end
  
  def average(method_name)
    value = 0.0
    length = @materials.length
    @materials.each do |m|
      value += m.send(method_name)
    end
    return value
  end
  
  def mode(method_name)
    r = @materials.collect{|m| m.send method_name}
    return r.mode
  end
  
  def median(method_name)
    r = @materials.collect{|m| m.send method_name}
    return r.median
  end
  
  def hardness
    0.5 * average(:hardness) + 0.35 * median(:hardness) + 0.15 * mode(:hardness)
  end
  
  def toughness
    0.5 * average(:toughness) + 0.35 * median(:toughness) + 0.15 * mode(:toughness)
  end
  
  
  def density
    a = 0
    @materials.each do |m|
      a += m.density
    end
    
    a/=@materials.length
    return a
  end
  
  def weight
    return size * density
  end
  
  
  def name
    return "#{durability} - #{shape}"
  end

  def get_icon
    return 277
  end
  
  def get_effects
  end
  
  def used_out?
    return durability <= 0
  end
  
  def what_it_is
    return "Unknown"
  end
  
  def size
    return @size.to_f
  end
  
end