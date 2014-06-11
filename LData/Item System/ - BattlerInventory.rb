class Game_Battler
  attr_accessor :inventory
  def inventory
    @inventory = Inventory.new(20) unless @inventory
    @inventory << ItemStack.new($data_items[1],10)
    return @inventory
  end
end