class Inventory # the class that handles what things the actor carries
  # does not prevent things that are not itemstacks to be in it
  attr_accessor :items
  attr_accessor :max_size
  def method_missing(a,*b,&c)
    @items.send a, *b, &c
  end
  
  def current_size
    return @items.length
  end
  
  def cannot_handle?
    @max_size  <= current_size
  end
  
  
  def initialize(size = 10)
    @items = []
    @max_size = size
  end
  
  def compact!
    @items.compact!
  end
  
  def transfer(target,itemstack)
    if target.cannot_handle?
      return false
    else
      target << itemstack
      delete itemstack
      return true
    end
  end
end