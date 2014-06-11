class UiPlayer < Window_Base
  def target
    return $game_player.battler
  end
  
  def initialize
    super(0,Graphics.height/5,Graphics.width / 4, Graphics.height / 6)
    refresh
    @mem_battler = :meow
  end
  
  def refresh
    self.contents.clear
    draw_actor_hp(target,0,0)
    draw_actor_mp(target,0,32)
  end
  
  def update
    if @mem_battler != $game_player
      refresh
    end
    @mem_battler = $game_player.clone
  end
end