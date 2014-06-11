class Sprite_ItemStack < Sprite
  attr_accessor :itemstack
  def initialize(vp=nil)
    super vp
    self.z = 0
    yield self if block_given?
    render
  end
  
  def icon_index
    begin
#~       @itemstack = @itemstack.compact
    return @itemstack.item.icon_index
  rescue
    return 1
  end
  
  end
  
  
  def render
    self.bitmap.clear if self.bitmap
    self.bitmap = Bitmap.new(24,24)
    
    
    cl_bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.bitmap.blt(0, 0, cl_bitmap, rect, 255)
  end
end