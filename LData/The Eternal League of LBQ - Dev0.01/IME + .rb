#==============================================================================
# ** Mouse Input Module
#==============================================================================
class << Mouse
  def Mouse.map_pos
    return nil if @pos == nil 
    x = ($game_map.display_x / 256) + (@pos[0] / 32)
    y = ($game_map.display_y / 256) + (@pos[1] / 32)
    return [x, y]
  end
  ## 地图真实坐标
  def Mouse.map_xy
    return nil if @pos == nil
    x = (@pos[0]+1000-16)*8-8007
    y = (@pos[1] + 1000-32)*8 -8007
    m = $game_map.adjust_x1(x)
    n = $game_map.adjust_y1(y)
    return [m, n]
  end
end

#==============================================================================
# ** Input
#==============================================================================
class << Input
  alias wor_input_upd_mouse update unless $@
  def Input.update
    wor_input_upd_mouse
    Mouse.update
  end
end

#==============================================================================
# ** Graphics
#==============================================================================
class << Graphics
  alias wor_graph_fadeout_mouse fadeout unless $@
  def Graphics.fadeout(frames = 1)
    $mousec.visible = false if !$mousec.nil?
    wor_graph_fadeout_mouse(frames) unless $@
  end
end