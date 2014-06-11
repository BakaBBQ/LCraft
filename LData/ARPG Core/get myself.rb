class Game_Interpreter
  def me
    return $game_map.events[event_id]
  end
  
  def you
    return $game_player
  end
end
