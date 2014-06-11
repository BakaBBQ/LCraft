class Game_Map
  #--------------------------------------------------------------------------
  # ● Adds an event from another map to the current map
  #--------------------------------------------------------------------------
  def add_event(mapid, eventid, x, y)
	map = load_data(sprintf("Data/Map%03d.rvdata2", mapid))
	map.events.each do |i, event|
	  if event.id == eventid
      if event.projectile?
        e = Projectile.new(@map_id,event)
      else
        e = Game_Event.new(@map_id, event)
      end
      
      yield e if block_given?
      e.moveto(x,y)
      @events[@events.length + 1] = e
	  end
	end
    SceneManager.scene.get_spriteset.refresh_characters
  end
  

  def add_projectile(mapid, eventid, x, y)
    map = load_data(sprintf("Data/Map%03d.rvdata2", mapid))
    map.events.each do |i, event|
      if event.id == eventid
          e = Projectile.new(@map_id,event)
        yield e if block_given?
        e.moveto(x,y)
        @projectiles << e
      end
    end
    SceneManager.scene.get_spriteset.refresh_characters
  end
  
  
  
  
  

end

class Scene_Map < Scene_Base
  def get_spriteset
	return @spriteset
  end
end