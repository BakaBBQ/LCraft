Game_Map = Class.new Game_Map.clone do
  attr_reader :itemstacks
  def setup(*args)
    super(*args)
    @itemstacks = Array.new(width){Array.new(height){Inventory.new}}
#~     @itemstacks[3][3][0] = ItemStack.new($data_items[11],10)
    10.times do |c|
       @itemstacks[3][3] << ItemStack.new($data_items[c + 1],10)
     end
     
  end
  
  
  def place_stack(stack,x,y)
    pos = @itemstacks[x][y]
    if pos.empty?
      pos << stack
    else
      if pos.last.can_combine?(stack)
        pos.combine stack
      else
        pos << stack
      end
    end
  end
  
end