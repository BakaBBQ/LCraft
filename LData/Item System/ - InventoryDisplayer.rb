class InventoryDisplayer < Window_ItemList
  attr_reader :inventory
  def initialize(rect, inventory)
    super(rect.x,rect.y,rect.width,rect.height)
    @inventory = inventory
  end
  
  
  def refresh
    super
    draw_inventory_size
  end
  
  def draw_inventory_size
    contents.font.size = 14
    text = "#{inventory.compact.length}/#{inventory.max_size}"
    h = text_size(text).height
    draw_text(0, contents.height - h, contents.width,h,text,2)
    contents.font.size = Font.default_size
  end
  
  #--------------------------------------------------------------------------
  # ● 查询列表中是否含有此物品
  #--------------------------------------------------------------------------
  def include?(item)
    return true
  end
  
  
  #--------------------------------------------------------------------------
  # ● 绘制项目
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
#~     puts @data, $game_map.itemstacks[3][3][0]
    if item
#~       msgbox item
      rect = item_rect(index)
      rect.width -= 4
      
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 获取列数
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  
  #--------------------------------------------------------------------------
  # ● 获取物品
  #--------------------------------------------------------------------------
  def item
    @data = @inventory
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # ● 绘制物品个数
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", item.quantity) ,2)
  end
  
  #--------------------------------------------------------------------------
  # ● 查询此物品是否可用
  #--------------------------------------------------------------------------
  def enable?(item)
    true
  end
  
  #--------------------------------------------------------------------------
  # ● 生成物品列表
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @inventory
    @data.push(nil) if @data.length == 0
end


  def cleanup
    puts "cleaning up!"
    @inventory.compact!
  end
  
end
