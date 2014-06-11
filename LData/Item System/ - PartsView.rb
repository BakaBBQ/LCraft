class PartsView < Window_ItemList
  attr_reader :body
  attr_accessor :help
  def initialize(rect, body)
    super(rect.x,rect.y,rect.width,rect.height)
    @body = body
    make_item_list
  end
  
  
  def col_max
    return 1
  end
  
   #--------------------------------------------------------------------------
  # ● 生成物品列表
  #--------------------------------------------------------------------------
  def make_item_list
    BodyParser.start @body.parts
    @data = BodyParser.result
    puts @data
  end
  
  def draw_item(index)
    puts "draw_item called"
    item = @data[index]
    
    if item
      puts "and item is there"
      
      left = item.part.name
      
      right = item.part.wielding
      puts right
      indent = item.indent
      
      
      left = " " * indent + left
      puts (left || right || indent)
      rect = item_rect(index)
      rect.width -= 4
      puts "and where is the text"
      draw_text(rect, right)
      draw_text(rect, left)
    end
  end
  

  

  #--------------------------------------------------------------------------
  # ● 调用帮助窗口的更新方法
  #--------------------------------------------------------------------------
  def call_update_help
    @help.part = item.part if item && @help
    @help.refresh if  @help
    puts @help
  end
  
end