class Game_Map
  attr_accessor :projectiles
  def projectiles_xy(x, y)
    @projectiles.select{|event| event.respond_to?(:projectile_collide)}.select {|event| event.pos?(x, y) }
  end
  
  def battlers_xy(x,y)
    b = @events.values
    b << $game_player
    return b.select{|battler| battler.x == x && battler.y == y &&! battler.erased}
  end
  
  def battlers
    return @events.values + [$game_player]
  end
  
end
class Game_Event
  attr_reader :erased
end


class Projectile
  attr_reader :erased
  def colliding_projectiles
    r = $game_map.projectiles_xy(self.x,self.y)
    return r.reject{|p| p == self || p.erased}
  end
  
  def colliding_battlers
    r = $game_map.battlers_xy(self.x,self.y)
    return r.reject{|b| b.erased}.reject{|b| b == self.owner}.reject{|b| b == self}
  end
  
end