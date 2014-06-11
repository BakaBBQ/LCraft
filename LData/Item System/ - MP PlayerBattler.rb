Game_Player = Class.new Game_Player.clone do
  attr_accessor :battler
  def fixed_battler
    return $game_party.leader
  end
  
  def battler
    return fixed_battler
  end
  
end
