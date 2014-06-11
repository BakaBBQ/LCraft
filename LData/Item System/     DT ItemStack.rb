class ItemStack
  attr_accessor :item, :quantity
  def initialize item, quantity
    @item = item
    @quantity = quantity
  end
  
  def pickedup
    $game_party.gain_item @item, @quantity
  end
  
  def combine(itemstack)
    if can_combine?(itemstack)
      self.quantity += itemstack.quantity
      itemstack.quantity = 0
    end
  end
  
  def can_combine?(itemstack)
    self.item == itemstack.item
  end
  
  def name
    return @item.name
  end
  
  def icon_index
    return @item.icon_index
  end
  
  
  def to_msg
    item_name = "#{@item.name}(s)"
    item_be      = @quantity > 1 ? "are" : "is"
    return "#{@quantity} #{item_name} #{item_be} under your feet"
  end
  
  
  #messages the log
  def on_step
    SceneManager.scene.log self.to_msg
  end
end