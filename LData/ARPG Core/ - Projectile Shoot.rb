# fuck you cannot add key when iterating
class Game_Map
  attr_accessor :projectile_tasks
  def projectile_tasks
    if @projectile_tasks
    else
      @projectile_tasks = []
    end
    return @projectile_tasks
  end
  
  #--------------------------------------------------------------------------
  # ● 更新事件
  #--------------------------------------------------------------------------
  def update_events
    things_to_clear = []
    
    e_cnt = 0
    @events.values.each_with_index do |e,i|
      unless e.erased
        e.update
#~         e_cnt += 1
      else
#~         e_cnt += 1
      end
      
    end
#~     t = Time.now
    @projectiles.each do |p|
      p.update
      if p.erased || p.hp <= 0
        @projectiles.delete p
      end
      
    end
    
    
#~     puts "#{Time.now - t}, #{@projectiles.length}"
    
    @common_events.each {|event| event.update }
    @projectile_tasks ||= []
    @projectile_tasks.each do |t|
        $game_map.add_projectile(2, t[0], t[1].x, t[1].y) do |e|
          e.direction = t[1].direction#t[1].direction
          e.angle= t[2] if t[2]
          e.owner = t[1]
        end
      end
    @projectile_tasks = []
  end
  
end

