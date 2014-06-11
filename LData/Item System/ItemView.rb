class ItemView < Scene_MenuBase
  def start
    super
    create_displayer
  end
  
  def create_displayer
    rect = Rect.new(0,0,Graphics.width/2, Graphics.height)
    @displayer = InventoryDisplayer.new(rect, $game_party.leader.inventory)
    
    rect = Rect.new(Graphics.width/2,0,Graphics.width/2,Graphics.height)
    inv =  $game_map.itemstacks[$game_player.x ][$game_player.y ]
#~     msgbox inv
    @target = InventoryDisplayer.new(rect,inv)
    
    @displayer.refresh
    @target.refresh
    
    @displayer.set_handler(:ok, method(:on_select_left))
    @target.set_handler(:ok, method(:on_select_right))
    @target.set_handler(:cancel, method(:on_cancel))
    @displayer.set_handler(:cancel, method(:on_cancel))
    
    @displayer.set_handler(:RIGHT, method(:on_key_right))
    @displayer.set_handler(:LEFT, method(:on_key_left))
    
    @displayer.activate
    @displayer.select(0)
    @target.select(0)
  end
  
  def update
    super
    on_key_right if Input.trigger?(:RIGHT)
    on_key_left if Input.trigger?(:LEFT)
  end
  
  
  def on_select_left
    @displayer.inventory.transfer(@target.inventory, @displayer.item)
    @displayer.activate
    refresh_both
  end
  
  def on_select_right
    @target.inventory.transfer(@displayer.inventory, @target.item)
    @target.activate
    refresh_both
  end
  
  def refresh_both
    @displayer.inventory.compact! unless @displayer.inventory.compact.length == 0
    @target.inventory.compact! unless @target.inventory.compact.length == 0
    @displayer.refresh
    @target.refresh
  end
  
  
  def on_cancel
    @displayer.cleanup
    @target.cleanup
    SceneManager.return
  end
  
  def on_key_right
    @displayer.deactivate
    @target.activate
    #@target.select(0)
  end
  
  def on_key_left
    @target.deactivate
    @displayer.activate
  end
  
end