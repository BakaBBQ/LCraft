#=========================================

class Window_WorldList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  #--------------------------------------------------------------------------
  # ● 设置分类
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # ● 获取列数
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # ● 获取项目数
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # ● 获取物品
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # ● 获取选择项目的有效状态
  #--------------------------------------------------------------------------
  def current_item_enabled?
    true
  end
  #--------------------------------------------------------------------------
  # ● 查询列表中是否含有此物品
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # ● 查询此物品是否可用
  #--------------------------------------------------------------------------
  def enable?(item)
    $game_party.usable?(item)
  end
  #--------------------------------------------------------------------------
  # ● 生成物品列表
  #--------------------------------------------------------------------------
  def make_item_list
    @data =  Dir.entries('Worlds').select {|entry| File.directory? File.join('Worlds',entry) and !(entry =='.' || entry == '..') }
  end
  #--------------------------------------------------------------------------
  # ● 返回上一个选择的位置
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  #--------------------------------------------------------------------------
  # ● 绘制项目
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      #rect.width -= 4
      draw_text(rect,item,1)
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 绘制物品个数
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end
  #--------------------------------------------------------------------------
  # ● 更新帮助内容
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # ● 刷新
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

class Scene_WorldLoad < Scene_Base
  def start
    super
    @bg = Plane.new
    @bg.bitmap = Cache.parallax "Mountains4"
    @main = Window_WorldList.new(0,0,Graphics.width,Graphics.height)
    @main.activate
    @main.z = 1
    @main.refresh
    @main.select(0)
    @main.set_handler(:ok,     method(:on_load))
    @main.set_handler(:cancel, method(:on_cancel))
  end
  
  def on_load
    
  end
  
  def on_cancel
    SceneManager.return
  end
  
end
