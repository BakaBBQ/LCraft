class Window_MemberList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 获取列数
  #--------------------------------------------------------------------------
  def col_max
    return 2
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
  # ● 生成物品列表
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_player.unit.members
  end
  
  #--------------------------------------------------------------------------
  # ● 绘制项目
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      leader = item.unit.leader
      n = item.name
      if leader == item
        n = "+#{item.name}+"
      end
      draw_text(rect, n, 1)
    end
  end
end


class Scene_Members < Scene_MenuBase
  def start
    super
    create_member_window
  end
  
  def create_member_window
    @members = Window_MemberList.new(0,0,Graphics.width / 2,Graphics.height)
    @members.make_item_list
    @members.refresh
    @members.select 0
    @members.activate
    @members.set_handler(:cancel, proc{SceneManager.return})
  end
  
end