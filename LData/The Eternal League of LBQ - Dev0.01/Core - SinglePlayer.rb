
#==============================================================================

class Window_WorldCategory < Window_HorzCommand
  #--------------------------------------------------------------------------
  # ● 定义实例变量
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
  end
  #--------------------------------------------------------------------------
  # ● 获取窗口的宽度
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● 获取列数
  #--------------------------------------------------------------------------
  def col_max
    return 3
  end
  #--------------------------------------------------------------------------
  # ● 生成指令列表
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("New",:new)
    add_command("Load",   :load)
    add_command("Delete",    :delete)
    #add_command(Vocab::key_item, :key_item)
  end
end


class Scene_SinglePlayer < Scene_Base
  def start
    super
    @bg = Plane.new
    @bg.bitmap = Cache.parallax "Mountains4"
    @dummies = []
    
    
    @mode = Window_WorldCategory.new
    @mode.refresh
    @mode.select(0)
    @mode.set_handler(:new,method(:new_world))
    @mode.set_handler(:load, method(:load_world))
    @mode.set_handler(:delete, method(:delete_world))
    @dummies << Window_Base.new(0,Graphics.height - @mode.height,Graphics.width,@mode.height)
    @main = Window_WorldList.new(0,@mode.height,Graphics.width,Graphics.height - 2 * @mode.height)
    #@main.activate
    @main.z = 1
    @main.refresh
    #@main.select(0)
    @main.set_handler(:ok,     method(:on_load))
    @main.set_handler(:cancel, method(:on_cancel))
  end
  
  
  def load_world
    @main.activate
    @main.select 0
    # current_symbol
  end
  
  def new_world
    @ime = SpriteIME.new
  end
  
  def delete_world
    @main.activate
    @main.select 0
  end
  
  
  def on_load
    if @mode.current_symbol == :delete
      FileUtils.rm_r "Worlds/#{@main.item}"
      @mode.activate
      @main.refresh
    else
      goto_world(@main.item)
    end
    
  end
  
  def on_cancel
    @mode.activate
    #@mode.select 0
  end
  
  def deal_with_ime
    @ime.update
    if Mouse.click?(1)
      @ime.dispose
      goto_world(@ime.get_words)
    elsif Mouse.click? 2
      @ime.dispose
      @ime = nil
      @mode.activate
    end
  end
  
  
  
  def update
    super
    deal_with_ime if @ime
    
  
#    @name.update#    @widget.update
 # goto_world("LBQ") if Mouse.click?(1)
  end
  
  def goto_world(name)
    DataManager.load_map(name)
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
  
  
  
end
