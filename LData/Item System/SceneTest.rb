class SceneTest < Scene_MenuBase
  def start
    super
    create_body_view
    create_part_info
  end
  
  def create_body_view
    rect = Rect.new(0,0,Graphics.width / 2, Graphics.height)
    @view = PartsView.new(rect, $game_party.leader.body)
    @view.refresh
    @view.activate
    @view.select(0)
  end
  
  def create_part_info
    @part_info = PartView.new(Graphics.width/2, Graphics.height * 2 /3, @view.item.part)
    @part_info.refresh
    @view.help = @part_info
  end
  
end


module Kernel
  def try(target, *args, &block)
    $test_target = target
    $test_args = args
    $test_block = block
    SceneManager.call(SceneTest)
  end
end

FULL_WINDOW = Rect.new(0,0,Graphics.width, Graphics.height)