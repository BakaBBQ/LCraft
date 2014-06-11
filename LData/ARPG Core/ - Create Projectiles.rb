class RPG::Event
  PROJECTILE_REGEX =  /<projectile=(\d+)>/
  def projectile?
    return PROJECTILE_REGEX.match(self.name)
  end
  
  def projectile_id
    md = PROJECTILE_REGEX.match(self.name)
    return md[1].to_i
  end
end

class Game_Map
  #--------------------------------------------------------------------------
  # ● 设置事件
  #--------------------------------------------------------------------------
  def setup_events
    @events = {}
    @projectiles = []
    @map.events.each do |i, event|
      if event.projectile?
        @projectiles << Projectile.new(@map_id,event)
        #@events[i].setup_projectile event.projectile_id
      else
        @events[@events.length + 1] = Game_Event.new(@map_id, event)
      end
      
    end
    @common_events = parallel_common_events.collect do |common_event|
      Game_CommonEvent.new(common_event.id)
    end
    refresh_tile_events
  end
end
